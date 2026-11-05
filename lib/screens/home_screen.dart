import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/price_provider.dart';

import 'comparison_screen.dart';
import 'add_price_screen.dart';
import 'price_history_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PriceWise',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF16834A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Favourites',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Price History',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PriceHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<PriceProvider>(
        builder: (context, provider, child) {

          // Loading state
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = provider.filteredProducts;

          return Column(
            children: [

              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: provider.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Category filters
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  children: [
                    'All',
                    'Dairy',
                    'Fruits',
                    'Vegetables',
                    'Groceries',
                  ].map((category) {
                    final isSelected =
                        provider.selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor:
                            const Color(0xFF16834A),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                        onSelected: (_) {
                          provider.updateCategory(category);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // Section heading
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Compare Product Prices',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${products.length} products',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Product list
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return ProductCard(
                            product: product,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // Add price button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF16834A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Price'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPriceScreen(),
            ),
          );
        },
      ),
    );
  }
}

// Product Card
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PriceProvider>();

    final userPrices =
        provider.getPricesForProduct(product.id);

    final lowestPrice = userPrices.isNotEmpty
        ? userPrices.first.price
        : product.lowestPrice;

    final shopCount = userPrices.isNotEmpty
        ? provider.getShopCountForProduct(product.id)
        : product.shopCount;

    final isFavorite =
        provider.isFavorite(product.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComparisonScreen(
                product: product,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [

              // Product emoji
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    product.emoji,
                    style: const TextStyle(
                      fontSize: 35,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Product information
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${product.category} • ${product.unit}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Lowest: ₹${lowestPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF16834A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    Text(
                      '$shopCount shops',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Favourite button
              IconButton(
                tooltip: isFavorite
                    ? 'Remove favourite'
                    : 'Add favourite',
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () async {
                  try {
                    await provider.toggleFavorite(product.id);
                  } catch (error) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Unable to update favourite.',
                        ),
                      ),
                    );
                  }
                },
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}