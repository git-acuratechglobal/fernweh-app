import 'package:dio/dio.dart';
import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../utils/common/common.dart';
import 'dio_exception.dart';
part 'dio_service.g.dart';

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio();
  final token = ref.watch(localStorageServiceProvider).getToken();
  dio.options = BaseOptions(
    headers: {
      'Authorization': "Bearer $token",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    baseUrl: "${Common.baseUrl}/api/",
    responseType: ResponseType.json,
    receiveTimeout: const Duration(minutes: 2),
    sendTimeout: const Duration(minutes: 2),
    connectTimeout: const Duration(minutes: 2),
  );
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true,requestHeader: true));
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (e, handler) {
        final message = DioExceptions.fromDioError(e);
        return handler.reject(
          DioException(requestOptions: e.requestOptions, error: message),
        );
      },
    ),
  );
  return dio;
}
