import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_service.dart';
import '../../data/models/product_model.dart';
import '../../data/repository/product_repository.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final productRepositoryProvider = Provider(
    (ref) => ProductRepository(ref.read(apiServiceProvider))
);



