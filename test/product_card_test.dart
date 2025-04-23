import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:e_commerce_listing_app/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("ProductCard displays title and price", (tester) async {
    final product = Product(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      discountPercentage: 10,
      rating: 4.5,
      stock: 10,
      thumbnail: 'https://via.placeholder.com/150',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ProductCard(
          product: product,
          isFavourite: false,
          onFavouriteToggle: () {},
        ),
      ),
    ));

    expect(find.text("Test Product"), findsOneWidget);
    expect(find.text('\$99.99'), findsWidgets);


  });
}
