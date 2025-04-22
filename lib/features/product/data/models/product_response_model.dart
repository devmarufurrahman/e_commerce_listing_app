import 'product_model.dart';

class ProductResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: List<Product>.from(
        json['products'].map((product) => Product.fromJson(product)),
      ),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}
