import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class SortSheet extends StatelessWidget {
  final List<Product> products;
  final void Function(List<Product>) onSorted;

  const SortSheet({
    super.key,
    required this.products,
    required this.onSorted,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            title: const Text("Price: Low to High"),
            onTap: () {
              List<Product> sorted = [...products]
                ..sort((a, b) => a.price.compareTo(b.price));
              onSorted(sorted);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Price: High to Low"),
            onTap: () {
              List<Product> sorted = [...products]
                ..sort((a, b) => b.price.compareTo(a.price));
              onSorted(sorted);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Rating"),
            onTap: () {
              List<Product> sorted = [...products]
                ..sort((a, b) => b.rating.compareTo(a.rating));
              onSorted(sorted);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
