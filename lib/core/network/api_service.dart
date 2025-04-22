import 'package:dio/dio.dart';
import 'package:e_commerce_listing_app/core/config/base_url.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Fetch all products from the API with pagination
  Future<Response> getProducts({int? limit, int? skip}) async {
    try{
      return await dio.get('/products', queryParameters: {
        'limit': limit,
        'skip': skip,
      });
    } catch(e){
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> searchProducts(String query) async {
    try{
      return await dio.get('/products/search', queryParameters: {
        'q': query,
      });
    } catch(e){
      throw Exception('Search failed: $e');
    }
  }

}