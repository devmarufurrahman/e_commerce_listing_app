import 'package:e_commerce_listing_app/core/network/api_service.dart';
import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:e_commerce_listing_app/features/product/data/models/product_response_model.dart';

class ProductRepository{
  final ApiService apiService;

  ProductRepository(this.apiService);

  // get product response from the API
  Future<ProductResponse> getProducts({int limit = 10, int skip = 0}) async {
    final response = await apiService.getProducts(limit: limit, skip: skip);
    return ProductResponse.fromJson(response.data);
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await apiService.searchProducts(query);
    List data = response.data['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }


}