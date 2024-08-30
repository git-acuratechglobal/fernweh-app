import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fernweh/view/auth/signup/profile_setup/profile_step/model/intrestedin_category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../view/auth/model/user_model.dart';
import '../dio_service/dio_service.dart';
import '../local_storage_service/local_storage_service.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService(
      ref.watch(dioProvider), ref.watch(localStorageServiceProvider));
}

class AuthService {
  final Dio _dio;
  final LocalStorageService _localStorageService;

  AuthService(this._dio, this._localStorageService);

  Future<User> login(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final response = await _dio.post('login', data: formData);
      final userJson = response.data["user"];
      final user = User.fromJson(userJson);
      await _localStorageService.setUser(user);
      await _localStorageService.setToken(user.token.toString());
      return user;
    });
  }

  Future<User> signUp(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
    final response=  await _dio.post('register-otp', data: formData);
    final userJson = response.data["user"];
    final user = User.fromJson(userJson);
    return user;
    });
  }

  Future<User> matchOtp(Map<String, dynamic> formData) async {
    return asyncGuard(() async {
      final response = await _dio.post('match-otp', data: formData);
      final userJson = response.data["user"];
      final user = User.fromJson(userJson);
      await _localStorageService.setUser(user);
      await _localStorageService.setToken(user.token.toString());
      return user;
    });
  }

  Future<List<IntrestedInCategory>> getCategories() async {
    return asyncGuard(() async {
      final response = await _dio.get('category');
      final categories = (response.data['categories'] as List)
          .map((json) => IntrestedInCategory.fromJson(json))
          .toList();
      return categories;
    });
  }

  Future<User> updateUser(Map<String, dynamic> userDetails) async {
    return asyncGuard(() async {
      final XFile? imagePath = userDetails['image'];
      if (imagePath != null) {
        userDetails['image'] = await MultipartFile.fromFile(imagePath.path);
      }
      final response = await _dio.post(
        'add-profile-info',
        data: FormData.fromMap(userDetails),
      );
      final userJson = response.data["user"];
      final user = User.fromJson(userJson);
      await _localStorageService.setUser(user);
      return user;
    });
  }

  Future<String> logOut(String token) async {
    print(token);
    return asyncGuard(() async {
      final response =
          await _dio.post('logout', data: FormData.fromMap({'token': token}));
      final message = response.data['message'];
      return message;
    });
  }
}

Future<T> asyncGuard<T>(Future<T> Function() future) async {
  try {
    return await future();
  } on DioException catch (e) {
    throw e.message ?? e.error.toString();
  } on FormatException catch (_) {
    throw "Unable to process data from server";
  } catch (e) {
    rethrow;
  }
}
