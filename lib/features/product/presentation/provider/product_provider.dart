import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_service.dart';
import '../../data/models/product_model.dart';
import '../../data/repository/product_repository.dart';

// api service call
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final productRepositoryProvider = Provider<ProductRepository>(
    (ref) => ProductRepository(ref.read(apiServiceProvider)));

// product list provider
final productListProvider =
    FutureProvider.family<List<Product>, int>((ref, page) async {
  final repository = ref.read(productRepositoryProvider);

  final response = await repository.getProducts(
    limit: 10,
    skip: page * 10,
  );

  return response.products;
});


 // search provider
final productSearchProvider =
FutureProvider.family<List<Product>, String>((ref, query) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.searchProducts(query);
});