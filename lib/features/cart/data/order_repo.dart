import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/cart/data/order_model.dart';

class OrderRepo {
  final ApiService _apiService = ApiService();

  /// ✅ Create Order
  Future<OrderData> createOrder(OrderRequestModel order) async {
    try {
      final response = await _apiService.post(
        '/orders',
        order.toJson(),
      );

      print(response);

      if (response['code'] != 201) {
        throw ApiError(message: response['message'] ?? 'Create order failed');
      }

      final result = CreateOrderResponseModel.fromJson(response);
      print(result.data);
      return result.data;
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }

  /// ✅ Get Orders History
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiService.get('/orders');

      if (response['code'] != 200) {
        throw ApiError(message: response['message'] ?? 'Load orders failed');
      }

      final ordersResponse = GetOrdersResponseModel.fromJson(response);
      return ordersResponse.data;
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }
}
