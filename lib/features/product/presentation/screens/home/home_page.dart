import 'dart:async';

import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/network_helper.dart';
import '../../provider/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/sort_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;
  Set<int> favouriteProductIds = {};


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

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  Future<void> loadInitialProducts() async {
    final isConnected = await NetworkHelper.isOnline();

    if (!isConnected) {
      print("Offline detected");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are offline. Showing cached data.")),
      );
    }

    final response = await ref
        .read(productListProvider(currentPage).future)
        .catchError((e) {
      print("Error from provider: $e");
      return [];
    });
    setState(() {
      products = response;
    });
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

  Future<void> loadSearchResults() async {
    setState(() {
      loadingMore = true;
    });

    final results = await ref
        .read(productSearchProvider(searchQuery).future)
        .catchError((e) => []);

    setState(() {
      products = results;
      loadingMore = false;
      hasMore = false;
    });
  }

  void showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SortSheet(
        products: products,
        onSorted: (sortedList) {
          setState(() {
            products = sortedList;
          });
        },
      ),
    );
  }

  void toggleFavourite(int productId) {
    setState(() {
      if (favouriteProductIds.contains(productId)) {
        favouriteProductIds.remove(productId);
      } else {
        favouriteProductIds.add(productId);
      }
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
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(milliseconds: 300), () {
                          setState(() {
                            searchQuery = value;
                            currentPage = 0;
                            products.clear();
                            hasMore = true;
                          });

                          if (searchQuery.isEmpty) {
                            loadInitialProducts();
                          } else {
                            loadSearchResults();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search Anything...",
                        prefix: const Icon(Icons.search, ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: showSortSheet,
                  )
                ],
              ),
            ),

            Expanded(
              child: products.isEmpty
                  ? const Center(child: CircularProgressIndicator(),)
                  : GridView.builder(
                controller: scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,

                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: products.length ,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    return ProductCard(
                      product: products[index],
                      isFavourite: favouriteProductIds.contains(products[index].id),
                      onFavouriteToggle: () => toggleFavourite(products[index].id),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
                ),

            ),


          ],
        ),
      ),
    );
  }
}
