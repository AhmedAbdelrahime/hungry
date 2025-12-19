import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_exception.dart';
import 'package:hungry/core/network/dio_clinet.dart';

class ApiService {
  final DioClinet _dioClinet = DioClinet();
  //crud method
  Future<dynamic> get(String endPoint , { dynamic params}) async {
    try {
      final response = await _dioClinet.dio.get(endPoint , queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      return ApiException.handleError(error);
    }
  }

  Future<dynamic> post(String endPoint, dynamic body) async {
    try {
      final response = await _dioClinet.dio.post(endPoint, data: body);
      return response.data;
    } on DioException catch (error) {
      return ApiException.handleError(error);
    }
  }

  Future<dynamic> put(String endPoint, dynamic body) async {
    try {
      final response = await _dioClinet.dio.put(endPoint, data: body);
      return response.data;
    } on DioException catch (error) {
      return ApiException.handleError(error);
    }
  }
Future<Map<String, dynamic>> delete(
  String endPoint,
  dynamic body,
  Map<String, dynamic>? params,
) async {
  try {
    final response = await _dioClinet.dio.delete(
      endPoint,
      data: body,
      queryParameters: params,
    );
    return response.data as Map<String, dynamic>;
  } on DioException catch (error) {
    throw ApiException.handleError(error); // 🔥 throw مش return
  }
}

}
