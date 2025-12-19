import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/cart/data/cart_model.dart';

class CartRepo {
  final ApiService _apiService = ApiService();
  Future<void> addToCartData(CartRequestModel cartData) async {
    try {
      final response = await _apiService.post('/cart/add', cartData.toJson());
      if (response['code'] != 200) {
        throw ApiError(message: response['message'] ?? 'Unknown error');
      }

      // success
      print('Added to cart successfully');
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  } 



  ///cart data
  Future<GetCartResponseModel> getCartData() async {
    try {
      final response = await _apiService.get('/cart');
      print('RAW CART RESPONSE => $response'); // 👈 مهم جدًا

      if (response['code'] != 200) {
        throw ApiError(message: response['message'] ?? 'Unknown error');
      }
      return GetCartResponseModel.fromJson(response);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //remove item from cart
Future<void> removeFromCart(int itemId) async {
  try {
    final response = await _apiService.delete(
      '/cart/remove/$itemId',
      {},
      null,
    );
print(response.runtimeType);

    if (response['code'] != 200) {
      throw ApiError(message: response['message'] ?? 'Unknown error');
    }
  } catch (e) {
    rethrow; // ✅ مهم
  }
}
//delete all cart
  Future<void> removeAllFromCart(List<int> itemIds) async {
  try {
    for (final id in itemIds) {
      await removeFromCart(id);
    }
  } catch (e) {
    rethrow;
  }
}
// داخل CartRepo
Future<void> updateQuantity(int itemId, int newQuantity) async {
  try {
    final response = await _apiService.put(
      '/cart/add/$itemId',            // endpoint تعديل كمية العنصر
      {
        'quantity': newQuantity,        // نرسل الكمية الجديدة
      },
    );

    print('Update quantity response => $response');

    if (response['code'] != 200) {
      throw ApiError(message: response['message'] ?? 'Unknown error');
    }
  } catch (e) {
    rethrow; // نخلي الـ UI يقدر يتعامل مع الخطأ
  }
}


}
