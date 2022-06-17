import 'package:dio/dio.dart';

extension DioErrorExtension on DioError {
  String formatApiErrorMsg() {
    return type == DioErrorType.response ? response.toString() : toString();
  }
}
