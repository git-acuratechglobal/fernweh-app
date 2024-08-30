import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_places.dart';
import 'package:fernweh/view/navigation/itinerary/models/states/my_itinerary_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../map/model/category.dart';
import '../models/itinerary_model.dart';
import '../models/states/itinerary_state.dart';

part 'itinerary_notifier.g.dart';

@Riverpod(keepAlive: true)
FutureOr<UserItinerary> getUserItinerary(GetUserItineraryRef ref) async {
  final userItinerary=await ref.watch(apiServiceProvider).getUserItinerary();
  return userItinerary;
}

@riverpod
class UserItineraryNotifier extends _$UserItineraryNotifier {
  final Map<String, dynamic> _formData = {};

  @override
  UserItineraryState build() => UserItineraryInitial();

  Future<void> createItinerary() async {
    try {
      state = UserItineraryLoading();
   final data=   await ref.watch(apiServiceProvider).createUserItinerary(_formData);
      ref.invalidate(getUserItineraryProvider);
      state = UserItineraryCreated(itinerary: data);
    } catch (e) {
      state = UserItineraryError(error: e.toString());
    }
  }

  Future<void> updateItinerary() async {
    try {
      state = SavedLoading();
      await ref.watch(apiServiceProvider).updateItinerary(_formData);
      ref.invalidate(getUserItineraryProvider);
      state = Saved();
    } catch (e) {
      state = UserItineraryError(error: e);
    }
  }

  Future<void> deleteItinerary() async {
    try {
      state = DeleteLoading();
      await ref.watch(apiServiceProvider).deleteItinerary(_formData);
      state = Deleted();
      ref.invalidate(getUserItineraryProvider);
    } catch (e) {
      state = UserItineraryError(error: e.toString());
    }
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }
}


@riverpod
class MyItineraryNotifier extends _$MyItineraryNotifier {
  final Map<String, dynamic> _formData = {};
  @override
  MyItineraryState build() =>MyItineraryInitialState();


Future<void> createMyItinerary() async {
  try{
    state=MyItineraryLoading();
    final data= await ref.watch(apiServiceProvider).createMyItinerary(_formData);
    state=MyItineraryCreatedState(myItinerary: data);
  }catch (e) {
    state = MyItineraryErrorState(error: e);
  }

}
  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }

}



@Riverpod(keepAlive: true)
class ItineraryPlacesNotifier extends _$ItineraryPlacesNotifier {
  @override
  FutureOr<List<ItineraryPlaces>> build() async {
    return [];
  }


  Future<void> getItineraryPlaces(int itineraryId)async{
    try {
      state=const AsyncLoading<List<ItineraryPlaces>>();
      final itineraryPlaces= await ref.read(apiServiceProvider).getItineraryPlace(itineraryId,null);
      state= AsyncData(itineraryPlaces);
    }catch(e,st){
      state= AsyncError<List<ItineraryPlaces>>(e,st);
    }
  }


  Future<void> getTypeItineraryPlace(int itineraryId, int? type) async{

     try{
       state=const AsyncLoading<List<ItineraryPlaces>>();
       final itineraryPlaces= await ref.read(apiServiceProvider).getItineraryPlace(itineraryId, type);
       state= AsyncData(itineraryPlaces);
     }catch(e,st){
       state= AsyncError<List<ItineraryPlaces>>(e,st);
     }

  }

}
