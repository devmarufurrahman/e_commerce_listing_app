import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_service.dart';
import '../../data/models/product_model.dart';
import '../../data/repository/product_repository.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final productRepositoryProvider = Provider(
    (ref) => ProductRepository(ref.read(apiServiceProvider))
);

final productListProvider = FutureProvider<Product>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  final response = await repository.getProducts();
  return response;
});


