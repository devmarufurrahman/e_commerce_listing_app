import 'package:e_commerce_listing_app/core/network/api_service.dart';
import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:e_commerce_listing_app/features/product/data/models/product_response_model.dart';
import 'package:hive/hive.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<ProductResponse> getProducts({int limit = 10, int skip = 0}) async {
    final cacheKey = 'products_page_$skip';
    final box = Hive.box('product_cache');

    try {
      final response = await apiService.getProducts(limit: limit, skip: skip);
      final responseData = response.data;
      await box.put(cacheKey, responseData);

      return ProductResponse.fromJson(responseData);
    } catch (e) {
      print("API failed. Trying Hive fallback for $cacheKey");
      final cachedData = box.get(cacheKey);

      if (cachedData != null && cachedData is Map) {
        try {
          final parsedMap = Map<String, dynamic>.from(cachedData as Map);
          print("Hive cache found for $cacheKey");
          return ProductResponse.fromJson(parsedMap);
        } catch (err) {
          print("Failed to parse cached data: $err");
          throw Exception('Invalid cached data');
        }
      } else {
        print("No Hive cache found for $cacheKey");
        throw Exception('No data available offline.');
      }
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await apiService.searchProducts(query);
    List data = response.data['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }
}
