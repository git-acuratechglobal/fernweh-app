import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fernweh/view/navigation/friends_list/controller/follow_friend_notifier.dart';
import 'package:fernweh/view/navigation/friends_list/model/following_friends.dart';
import 'package:fernweh/view/navigation/friends_list/model/friends_itinerary.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_model.dart';
import 'package:fernweh/view/navigation/itinerary/models/trip/trip.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/add_notes/model/notes_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../view/navigation/explore/categories_model/categories_model.dart';
import '../../view/navigation/explore/search_filter/model/search_result.dart';
import '../../view/navigation/friends_list/controller/friends_notifier.dart';
import '../../view/navigation/friends_list/model/friends.dart';
import '../../view/navigation/itinerary/models/create_itinerary_model.dart';
import '../../view/navigation/itinerary/models/itinerary_places.dart';
import '../../view/navigation/itinerary/models/my_itinerary.dart';
import '../../view/navigation/map/model/category.dart';
import '../auth_service/auth_service.dart';
import '../dio_service/dio_service.dart';
import '../local_storage_service/local_storage_service.dart';

part 'api_service.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(Ref ref) {
  return ApiService(ref.watch(dioProvider),
      ref.watch(localStorageServiceProvider).getToken());
}

class ApiService {
  final Dio _dio;
  final String? _token;

  ApiService(this._dio, this._token);

  Future<List<Category>> getCategory(String? latitude, String? longitude,
      {required Map<String, dynamic> filter}) async {
    return asyncGuard(() async {
      final response = await _dio.post(
        'attractions',
        data: filter['input'] == null
            ? FormData.fromMap({
                "latitude": latitude,
                "longitude": longitude,
                "type": filter['type'],
                "rating": filter['rating'],
                "radius": filter['radius'],
                "sort_by": filter['sort_by'],
                "search_term": filter['search_term'],
              })
            : FormData.fromMap({
                "latitude": latitude,
                "longitude": longitude,
                "type": filter['type'],
                "input": filter['input'],
              }),
      );

      final List<dynamic> categoryJson = response.data["results"];
      final category = categoryJson.map((e) => Category.fromJson(e)).toList();
      return category;
    });
  }

  Future<List<Categories>> getCategories() async {
    return asyncGuard(() async {
      final response = await _dio.get('category',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> categoriesJson = response.data["categories"];
      final categories =
          categoriesJson.map((e) => Categories.fromJson(e)).toList();
      return categories;
    });
  }

  Future<UserItinerary> getUserItinerary() async {
    return asyncGuard(() async {
      final response = await _dio.post('itinerary/get-shared-user',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final userItineraryJson = response.data;
      final userItinerary = UserItinerary.fromJson(userItineraryJson);
      return userItinerary;
    });
  }

  Future<ItineraryModel> createUserItinerary(
      Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final XFile? imagePath = formData['image'];
      if (imagePath != null) {
        formData['image'] = await MultipartFile.fromFile(imagePath.path);
      }
      final response = await _dio.post('itinerary/create',
          data: FormData.fromMap(formData),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final createdItineraryJson = response.data["data"];
      final createdItinerary = ItineraryModel.fromJson(createdItineraryJson);
      return createdItinerary;
    });
  }

  Future<UserItinerary> updateItinerary(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final id = formData['id'];
      formData.remove('id');
      final XFile? imagePath = formData['image'];
      if (imagePath != null) {
        formData['image'] = await MultipartFile.fromFile(imagePath.path);
      }
      final response = await _dio.post('itinerary/update/$id',
          data: FormData.fromMap(formData),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final updatedItineraryJson = response.data["data"];
      final updatedItinerary = UserItinerary.fromJson(updatedItineraryJson);
      return updatedItinerary;
    });
  }

  Future<String> deleteItinerary(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final id = formData['id'];
      final response = await _dio.post('itinerary/delete/$id',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["message"];
    });
  }

  Future<MyItinerary> createMyItinerary(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final response = await _dio.post('itinerary/user-itinerary-create',
          data: FormData.fromMap(formData),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final myItineraryJson = response.data["data"];
      final myItinerary = MyItinerary.fromJson(myItineraryJson);
      return myItinerary;
    });
  }

  Future<String> updateMyItinerary(
      Map<String, dynamic> formData, int id) async {
    return asyncGuard(() async {
      final response = await _dio.post('itinerary/user-itinerary-update/$id',
          data: FormData.fromMap(formData),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final myItineraryJson = response.data["message"];

      return myItineraryJson;
    });
  }

  Future<List<SearchResult>> getPlaceSearch(String search) async {
    return asyncGuard(() async {
      var url =
          'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$search&key=AIzaSyCG4YZMnrZwDGA2sXcUF4XLQdddSL4tz5Y';
      var response = await _dio.get(url);
      final List<dynamic> jsonList = response.data['predictions'];
      return jsonList.map((place) => SearchResult.fromJson(place)).toList();
    });
  }

  Future<List<SearchResult>> getCityAndStateSearch(String search) async {
    return asyncGuard(() async {
      var url =
          'https://maps.googleapis.com/maps/api/place/queryautocomplete/json'
          '?input=$search'
          '&types=(cities)' // Restrict to a specific country, or leave it out to be global
          '&key=AIzaSyCG4YZMnrZwDGA2sXcUF4XLQdddSL4tz5Y';
      var response = await _dio.get(url);
      final List<dynamic> jsonList = response.data['predictions'];
      return jsonList.map((place) => SearchResult.fromJson(place)).toList();
    });
  }

  Future<List<ItineraryPlaces>> getItineraryPlace(int id, int? type) async {
    return asyncGuard(() async {
      final data = FormData.fromMap({'type': type});
      final response = await _dio.post('itinerary/detail/$id',
          data: data,
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonList = response.data['data'];
      return jsonList.map((place) => ItineraryPlaces.fromJson(place)).toList();
    });
  }

  Future<List<Friends>> addFriends() async {
    return asyncGuard(() async {
      final response = await _dio.post('user-management',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonList = response.data['data'];
      return jsonList.map((friend) => Friends.fromJson(friend)).toList();
    });
  }

  Future<String> sendRequest(int id, int status) async {
    return asyncGuard(() async {
      final response = await _dio.post('user-management/send-request',
          data: FormData.fromMap({
            'friendUserId': id,
            'status': status,
          }),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["data"]["friendUserId"];
    });
  }

  Future<PaginationResponse<Friends>> getFriends(int page,
      {String? search}) async {
    return asyncGuard(() async {
      final response = await _dio.post('user-management/friend-list?page=$page',
          data: search != null ? FormData.fromMap({"search": search}) : null,
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonList = response.data['data'];
      final friendList =
          jsonList.map((friend) => Friends.fromJson(friend)).toList();
      return PaginationResponse(
          currentPage: response.data["current_page"],
          totalPages: response.data["last_page"],
          data: friendList);
    });
  }

  Future<List<Friends>> friendRequest() async {
    return asyncGuard(() async {
      final response = await _dio.post('user-management/friend-request-list',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonList = response.data['data'];
      return jsonList.map((friend) => Friends.fromJson(friend)).toList();
    });
  }

  Future<String> acceptRequest(int userId, int status) async {
    return asyncGuard(() async {
      final response = await _dio.post('user-management/accept-request',
          data: FormData.fromMap({"status": status, "userId": userId}),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["data"]['userId'].toString();
    });
  }

  Future<String> rejectRequest() async {
    return asyncGuard(() async {
      final response = await _dio.post('user-management/delete',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["data"]["friendUserId"];
    });
  }

  Future<FollowFriendState> followUser({required int id}) async {
    return asyncGuard(() async {
      final response = await _dio.post('follow-user',
          data: {"follow": id},
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final message = response.data["message"];
      return FollowFriendState(message: message, id: id);
    });
  }

  Future<List<FollowingFriends>> getFollowingFriends() async {
    return asyncGuard(() async {
      final response = await _dio.get('get-followings',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonList = response.data['followings'];
      final followingFriendList =
          jsonList.map((friend) => FollowingFriends.fromJson(friend)).toList();
      return followingFriendList;
    });
  }

  Future<List<Friends>> searchFriends(String? search) async {
    final response = await _dio.post('user-management',
        data: {'search': search},
        options: Options(headers: {
          'Authorization': "Bearer $_token",
        }));
    final List<dynamic> jsonList = response.data['data'];

    return jsonList.map((e) => Friends.fromJson(e)).toList();
  }

  Future<String> shareItinerary(
      Map<String, dynamic> data, String itineraryId) async {
    return asyncGuard(() async {
      data.remove("itineraryId");
      final response = await _dio.post('itinerary/shared/$itineraryId',
          data: data,
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["success"];
    });
  }

  Future<String> unShareItinerary(
      Map<String, dynamic> data, String itineraryId) async {
    return asyncGuard(() async {
      data.remove("itineraryId");
      final response = await _dio.post('itinerary/remove/$itineraryId',
          data: data,
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["success"];
    });
  }

  Future<String> inviteFriend(String email) async {
    return asyncGuard(() async {
      final response = await _dio.post('itinerary/share-by-mail',
          data: FormData.fromMap({'email': email}),
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      return response.data["message"];
    });
  }

  Future<String> addNote(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final response =
          await _dio.post('itinerary/user-itinerary-management/create-notes',
              data: FormData.fromMap(formData),
              options: Options(headers: {
                'Authorization': "Bearer $_token",
              }));
      final note = response.data["message"];
      return note;
    });
  }

  Future<List<Notes>> getNotes(int itineraryId) async {
    return asyncGuard(() async {
      final response = await _dio.post(
          'itinerary/user-itinerary-management/get-notes/$itineraryId',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonNotes = response.data["data"];
      final notesList = jsonNotes.map((e) => Notes.fromJson(e)).toList();
      return notesList;
    });
  }

  Future<List<Itinerary>> getFriendsItinerary(int userId) async {
    return asyncGuard(() async {
      final response =
          await _dio.post('user-management/friend-itinerary-list/$userId',
              options: Options(headers: {
                'Authorization': "Bearer $_token",
              }));
      final List<dynamic> jsonItinerary = response.data["data"];
      final itineraryList =
          jsonItinerary.map((e) => Itinerary.fromJson(e)).toList();
      return itineraryList;
    });
  }

  Future<String> createTrip(
      {required String startDate,
      required String endDate,
      required String goingTo}) async {
    return asyncGuard(() async {
      final response = await _dio.post("add-trip",
          data: {
            "start_date": startDate,
            "end_date": endDate,
            "going_to": goingTo
          },
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final responseData = response.data['message'];
      return responseData;
    });
  }
  Future<String> editTrip(
      {required String startDate,
        required String endDate,
       required int id,
        required String goingTo
      }) async {
    return asyncGuard(() async {
      final response = await _dio.post("edit-trip/$id",
          data: {
            "start_date": startDate,
            "end_date": endDate,
            "location": goingTo
          },
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final responseData = response.data['message'];
      return responseData;
    });
  }
  Future<String> deleteTrip(
      {
        required int id}) async {
    return asyncGuard(() async {
      final response = await _dio.post("delete-trip/$id",
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final responseData = response.data['message'];
      return responseData;
    });
  }
  Future<List<Trip>> getTrip() {
    return asyncGuard(() async {
      final response = await _dio.post('get-trips',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final List<dynamic> jsonTripData = response.data['trips'];
      final tripData = jsonTripData.map((trip) => Trip.fromJson(trip)).toList();
      return tripData;
    });
  }

  Future<String> getFullAdress({required String placeId}) {
    return asyncGuard(() async {
      final url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=AIzaSyCG4YZMnrZwDGA2sXcUF4XLQdddSL4tz5Y";
      final response = await _dio.get(url);
      final data = response.data['result'];
      final List<dynamic> addressComponents = data['address_components'];

      final String? city = addressComponents.firstWhere(
          (entry) => entry['types'].contains('locality'),
          orElse: () => null)?['long_name'];
      final String? state = addressComponents.firstWhere(
          (entry) => entry['types'].contains('administrative_area_level_1'),
          orElse: () => null)?['long_name'];
      final String? country = addressComponents.firstWhere(
          (entry) => entry['types'].contains('country'),
          orElse: () => null)?['long_name'];
      final String? town = addressComponents.firstWhere(
              (entry) => entry['types'].contains('postal_town'),
          orElse: () => null)?['long_name'];
      final String? state2 = addressComponents.firstWhere(
              (entry) => entry['types'].contains('administrative_area_level_2'),
          orElse: () => null)?['long_name'];
      return "${city??town},${state??state2},$country";
    });
  }

  Future<String?> getPlaceIdFromCoordinates(Position position) async {
    return asyncGuard(() async {
      const apiKey =
          "AIzaSyCG4YZMnrZwDGA2sXcUF4XLQdddSL4tz5Y"; // Replace with your API Key
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";
      final response = await _dio.get(url);
      final data = response.data;
      final placeId = data['results'][0]['place_id'];
      return placeId;
    });
  }

  Future<TripDetails> getTripDetails({required int id}) async {
    return asyncGuard(() async {
      final response = await _dio.post('get-trip-detail/$id',
          options: Options(headers: {
            'Authorization': "Bearer $_token",
          }));
      final tripJson = response.data['trip'];
      final List<dynamic> friendTripsJson = response.data['friends_trips'];
      final trip = Trip.fromJson(tripJson);
      final friendsTrips =
          friendTripsJson.map((e) => FriendsTrip.fromJson(e)).toList();
      return TripDetails(trip: trip, friendsTrips: friendsTrips);
    });
  }
}
