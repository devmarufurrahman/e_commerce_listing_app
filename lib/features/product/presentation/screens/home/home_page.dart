import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController scrollController = ScrollController();

  List<Product> products = [];
  int currentPage = 0;
  bool loadingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    loadInitialProducts();

    scrollController.addListener((){
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && !loadingMore && hasMore){
        loadMoreProducts();
      }
    });
  }

  Future<void> loadInitialProducts() async {
    final response = await ref
        .read(productListProvider(currentPage).future)
        .catchError((e) => []);
    products = response;
  }

  Future<void> loadMoreProducts() async {
    setState(() {
      currentPage++;
      loadingMore = true;
    });

    final newProducts = await ref
        .read(productListProvider(currentPage).future)
        .catchError((e) => []);

    setState(() {
      if (newProducts.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(newProducts);
      }
      loadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
