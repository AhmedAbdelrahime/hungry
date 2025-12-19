import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';

class ApiException {
  static ApiError handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map<String, dynamic> && data['message'] != null) {
      return ApiError(message: data['message'], stutusCode: statusCode);
    }
    print(data);
    print(statusCode);
    if (statusCode == 302) {
      return ApiError(
        message: 'This email already used',
        stutusCode: statusCode,
      );
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: 'connection Timeout!');
      case DioExceptionType.badResponse:
        return ApiError(
          message: 'Bad Response!  Please try again later ! ',
          stutusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiError(message: 'connection Error!');
      case DioExceptionType.cancel:
        return ApiError(message: error.toString());
      case DioExceptionType.receiveTimeout:
        return ApiError(message: 'connection Error!');
      case DioExceptionType.sendTimeout:
        return ApiError(message: 'connection Error!');
      case DioExceptionType.unknown:
        return ApiError(message: error.toString());

      // case DioExceptionType.badCertificate:
      //   return ApiError(message: error.toString());

      default:
        return ApiError(message: 'Some thing went wrong !');
    }
  }
}
