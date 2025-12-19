import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/home/data/models/proudect_model.dart';
import 'package:hungry/features/home/data/models/toppings_model.dart';

class ProudectRepo {
  final ApiService _apiService = ApiService();

  Future<List<ProudectModel>> getProudects() async {
    try {
      final response = await _apiService.get('/products');
      return (response['data'] as List)
          .map((proudect) => ProudectModel.fromJson(proudect))
          .toList();
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<List<CategoriesModel>> getCategories() async {
    try {
      final response = await _apiService.get('/categories');
      print(response);
      return (response['data'] as List)
          .map((category) => CategoriesModel.fromJson(category))
          .toList();
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //search

  // Search products by name or description
  Future<List<ProudectModel>> searchProducts(String query) async {
    try {
      final response = await _apiService.get(
        '/products/',
        params: {'name': query},
      ); // جلب كل المنتجات
      final products = (response['data'] as List)
          .map((proudect) => ProudectModel.fromJson(proudect))
          .toList();

      if (query.isEmpty) return products;

      final filtered = products.where((p) {
        final name = p.name.toLowerCase();
        final desc = p.desc.toLowerCase();
        final q = query.toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList();

      return filtered;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  //category

  //get Toppings
  Future<List<ToppingsModel>> getToppings() async {
    try {
      final response = await _apiService.get('/toppings');
      return (response['data'] as List)
          .map((topping) => ToppingsModel.fromJson(topping))
          .toList();
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  } //get side options

  Future<List<ToppingsModel>> getSideOptions() async {
    try {
      final response = await _apiService.get('/side-options');
      return (response['data'] as List)
          .map((sideOptions) => ToppingsModel.fromJson(sideOptions))
          .toList();
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
