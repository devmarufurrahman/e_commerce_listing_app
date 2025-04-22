class Product {
  final int id;
  final String title;
  final num price;
  final num discountPercentage;
  final num rating;
  final int stock;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      discountPercentage: json['discountPercentage'],
      rating: json['rating'],
      stock: json['stock'],
      thumbnail: json['thumbnail'],
    );
  }
}
