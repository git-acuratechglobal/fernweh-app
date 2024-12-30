import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/auth/model/user_model.dart';
import '../../view/navigation/collections/models/itinerary_model.dart';

part 'local_storage_service.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  return throw UnimplementedError();
}

@Riverpod(keepAlive: true)
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
}

class LocalStorageService {
  final SharedPreferences _preferences;
  static const String _onBoarding = "onboarding";
  static const String _user = "user";
  static const String _token = "token";
  static const String _guestLogin = "guest";
  static const String _selectedItineraryId = "itinerary_id";
  static const String _userItinerary = "userItinerary";
  static const String _sharedItinerary = "sharedItinerary";
  static const String _collaborateList = "collaborateList";

  LocalStorageService(this._preferences);

  Future<void> setUser(User user) async {
    await _preferences.setString(_user, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final user = _preferences.getString(_user);
    return user == null ? null : User.fromJson(jsonDecode(user));
  }

  Future<void> setToken(String token) async {
    await _preferences.setString(_token, token);
  }

  String? getToken() {
    return _preferences.getString(_token);
  }

  void setOnboarding() async {
    await _preferences.setBool(_onBoarding, true);
  }

  bool? getOnboarding() {
    return _preferences.getBool(_onBoarding);
  }

  void setGuestLogin() async {
    await _preferences.setBool(_guestLogin, true);
  }

  bool? getGuestLogin() {
    return _preferences.getBool(_guestLogin);
  }

  Future<void> setItineraryId(int id) async {
    await _preferences.setInt(_selectedItineraryId, id);
  }

  int? getItineraryId() {
    return _preferences.getInt(_selectedItineraryId);
  }

  Future<void> setUserItinerary(List<Itenery> userItineraries) async {
    await _preferences.setString(_userItinerary,
        jsonEncode(userItineraries.map((e) => e.toJson()).toList()));
  }

  List<Itenery>? getUserItinerary(List<Itenery> apiList) {
    final userItinerary = _preferences.getString(_userItinerary);

    if (userItinerary == null) {
      return apiList;
    }
    List<dynamic> jsonList = jsonDecode(userItinerary);
    List<Itenery> localList = jsonList.map((e) => Itenery.fromJson(e)).toList();
    localList.removeWhere((localItem) => !apiList
        .any((apiItem) => apiItem.itinerary?.id == localItem.itinerary?.id));
    for (var apiItem in apiList) {
      var localItemIndex = localList.indexWhere(
          (localItem) => localItem.itinerary?.id == apiItem.itinerary?.id);
      if (localItemIndex != -1) {
        var localItem = localList[localItemIndex];
        if (localItem.itinerary?.name != apiItem.itinerary?.name ||
            localItem.itinerary?.image != apiItem.itinerary?.image ||
            localItem.canEdit != apiItem.canEdit ||
            localItem.canView != apiItem.canView ||
            localItem.placesCount != apiItem.placesCount) {
          localList[localItemIndex] = apiItem;
        }
      } else {
        localList.add(apiItem);
      }
    }
    return localList;
  }

  Future<void> setSharedItinerary(List<Itenery> sharedItineraries) async {
    await _preferences.setString(_sharedItinerary,
        jsonEncode(sharedItineraries.map((e) => e.toJson()).toList()));
  }

  List<Itenery>? getSharedItinerary(List<Itenery> apiList) {
    final sharedItinerary = _preferences.getString(_sharedItinerary);
    if (sharedItinerary == null) {
      return apiList;
    }
    List<dynamic> jsonList = jsonDecode(sharedItinerary);
    List<Itenery> localList = jsonList.map((e) => Itenery.fromJson(e)).toList();
    localList.removeWhere((localItem) => !apiList
        .any((apiItem) => apiItem.itinerary?.id == localItem.itinerary?.id));
    for (var apiItem in apiList) {
      var localItemIndex = localList.indexWhere(
          (localItem) => localItem.itinerary?.id == apiItem.itinerary?.id);
      if (localItemIndex != -1) {
        var localItem = localList[localItemIndex];
        if (localItem.itinerary?.name != apiItem.itinerary?.name ||
            localItem.itinerary?.image != apiItem.itinerary?.image ||
            localItem.canEdit != apiItem.canEdit ||
            localItem.canView != apiItem.canView ||
            localItem.placesCount != apiItem.placesCount) {
          localList[localItemIndex] = apiItem;
        }
      } else {
        localList.add(apiItem);
      }
    }
    return localList;
  }

  Future<void> setCollaborateList(List<Itenery> collaborateList) async {
    await _preferences.setString(_collaborateList,
        jsonEncode(collaborateList.map((e) => e.toJson()).toList()));
  }

  List<Itenery>? getCollaborateList(List<Itenery> apiList) {
    final collaborateList = _preferences.getString(_collaborateList);
    if (collaborateList == null) {
      return apiList;
    }
    List<dynamic> jsonList = jsonDecode(collaborateList);
    List<Itenery> localList = jsonList.map((e) => Itenery.fromJson(e)).toList();
    localList.removeWhere((localItem) => !apiList
        .any((apiItem) => apiItem.itinerary?.id == localItem.itinerary?.id));
    for (var apiItem in apiList) {
      var localItemIndex = localList.indexWhere(
          (localItem) => localItem.itinerary?.id == apiItem.itinerary?.id);
      if (localItemIndex != -1) {
        var localItem = localList[localItemIndex];
        if (localItem.itinerary?.name != apiItem.itinerary?.name ||
            localItem.itinerary?.image != apiItem.itinerary?.image ||
            localItem.canEdit != apiItem.canEdit ||
            localItem.canView != apiItem.canView ||
            localItem.placesCount != apiItem.placesCount) {
          localList[localItemIndex] = apiItem;
        }
      } else {
        localList.add(apiItem);
      }
    }
    return localList;
  }

  Future<void> clearSession() async {
    await _preferences.remove(_user);
    await _preferences.remove(_selectedItineraryId);
    await _preferences.remove(_token);
    await _preferences.remove(_sharedItinerary);
    await _preferences.remove(_userItinerary);
  }

  Future<void> clearGuestSession() async {
    await _preferences.remove(_guestLogin);
  }

  Future<void> clearSavedItineraryId() async {
    await _preferences.remove(_selectedItineraryId);
  }
}
