import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();

  API() {
    /// Test url
    // _dio.options.baseUrl = "https://agstask.online/public/api/";
    /// live url
    _dio.options.baseUrl = "https://asvtbangalore.com/public/api/";
    _dio.interceptors.add(PrettyDioLogger(
      request: false,
      responseBody: false,
    ));
  }

  Dio get dio => _dio;
}
