import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/auth/model/user_model.dart';
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
  static const String _guestLogin="guest";
  static const String _selectedItineraryId = "itinerary_id";
  LocalStorageService(this._preferences);

  Future<void> setUser(User user) async {
    await _preferences.setString(_user, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final user = _preferences.getString(_user);
    return user == null ? null : User.fromJson(jsonDecode(user));
  }

  Future<void> setToken(String token)async {
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

  Future<void> setItineraryId(int id)async{
     await _preferences.setInt(_selectedItineraryId, id);
  }

  int? getItineraryId() {
    return _preferences.getInt(_selectedItineraryId);
  }

  Future<void> clearSession() async {
   await _preferences.remove(_user);
   await _preferences.remove(_selectedItineraryId);
   await _preferences.remove(_token);
  }

  Future<void> clearGuestSession() async {
    await _preferences.remove(_guestLogin);
  }
  Future<void> clearSavedItineraryId()async{
    await _preferences.remove(_selectedItineraryId);
  }
}
