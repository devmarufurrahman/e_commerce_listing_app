import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("Sort products by pricing Low to High", (){
    final products = [
      Product(id: 1, title: 'Product A', price: 20.0, discountPercentage: 0, rating: 4.5, stock: 10, thumbnail: ''),
      Product(id: 2, title: 'Product B', price: 10.0, discountPercentage: 0, rating: 4.2, stock: 10, thumbnail: ''),
    ];


    products.sort((a,b)=> a.price.compareTo(b.price));

    expect(products.first.price, 10.0);
    expect(products.last.price, 20.0);

  });
}