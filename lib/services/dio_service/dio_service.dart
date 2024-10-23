import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../utils/common/common.dart';
import 'dio_exception.dart';
part 'dio_service.g.dart';

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final dio = Dio();
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );
  dio.options = BaseOptions(
    baseUrl: "${Common.baseUrl}/api/",
    responseType: ResponseType.json,
    receiveTimeout: const Duration(minutes: 2),
    sendTimeout: const Duration(minutes: 2),
    connectTimeout: const Duration(minutes: 2),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.d(
          "REQUEST:\n"
              "URL: ${options.baseUrl}${options.path}\n"
              "Headers: ${options.headers}\n"
              "Method: ${options.method}\n"
              "Body: ${options.data}",
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.d(
          "RESPONSE:\n"
              "URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}\n"
              "Status Code: ${response.statusCode}\n"
              "Data: ${response.data}",
        );
        return handler.next(response);
      },
      onError: (e, handler) {
        final message = DioExceptions.fromDioError(e);
        logger.e(
          "ERROR:\n"
              "URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}\n"
              "Message: $message\n"
              "Error: ${e.error}",
        );
        return handler.next(e);
      },
    ),
  );
  return dio;
}
