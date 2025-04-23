import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_listing_app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;

  const ProductCard(
      {super.key,
      required this.product,
      required this.isFavourite,
      required this.onFavouriteToggle});

  @override
  Widget build(BuildContext context) {
    final price = product.price;
    final discount = product.discountPercentage;
    final discountedPrice = (price * (1 - discount / 100)).truncate();

    return Stack(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text("\$${discountedPrice}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text(
                      "\$${product.price.truncate()}",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${product.discountPercentage.truncate()}% OFF",
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text("${product.rating}"),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("(${product.stock})"),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onFavouriteToggle,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: isFavourite ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
        if (product.stock == 0)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Out Of Stock",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
