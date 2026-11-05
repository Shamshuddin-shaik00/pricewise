import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/price_provider.dart';
import 'comparison_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'My Favourites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Consumer<PriceProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favoriteProducts;

          // Empty favourites screen
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No Favourites Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tap the heart icon to save products.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Display favourite products
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,

            itemBuilder: (context, index) {
              final product = favorites[index];

              final prices =
                  provider.getPricesForProduct(product.id);

              final lowestPrice = prices.isNotEmpty
                  ? prices.first.price
                  : product.lowestPrice;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1,

                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  // Product emoji
                  leading: Text(
                    product.emoji,
                    style: const TextStyle(
                      fontSize: 32,
                    ),
                  ),

                  // Product name
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  // Lowest price
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Lowest price: ₹${lowestPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF16834A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Remove from favourites
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    tooltip: 'Remove from favourites',
                    onPressed: () {
                      provider.toggleFavorite(product.id);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.name} removed from favourites',
                          ),
                          duration:
                              const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  // Open comparison screen
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ComparisonScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}