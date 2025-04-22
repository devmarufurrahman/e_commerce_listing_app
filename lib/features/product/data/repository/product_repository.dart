import 'package:e_commerce_listing_app/core/network/api_service.dart';
import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';

class ProductRepository{
  final ApiService apiService;

  ProductRepository(this.apiService);

  // get product response from the API
  Future<Product> getProducts({int? limit, int? skip}) async {
    try{
      final response = await apiService.getProducts(limit: limit, skip: skip);
      return Product.fromJson(response.data);
    } catch(e){
      rethrow;
    }
  }

  Future<Product> searchProducts(String query) async {
    try {
      final response = await apiService.searchProducts(query);
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }


}