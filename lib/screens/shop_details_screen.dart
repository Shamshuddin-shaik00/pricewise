import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/price_provider.dart';

class ShopDetailsScreen extends StatelessWidget {
  final String shopName;
  final String area;

  const ShopDetailsScreen({
    super.key,
    required this.shopName,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'Shop Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Consumer<PriceProvider>(
        builder: (context, provider, child) {
          final shopPrices = provider.shopPrices.where((item) {
            return item.shopName.trim().toLowerCase() ==
                    shopName.trim().toLowerCase() &&
                item.area.trim().toLowerCase() ==
                    area.trim().toLowerCase();
          }).toList();

          shopPrices.sort(
            (a, b) => a.price.compareTo(b.price),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shop information
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFFE5F5E9),
                        child: Icon(
                          Icons.store,
                          size: 38,
                          color: Color(0xFF16834A),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        shopName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF16834A),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              area,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '${shopPrices.length} submitted price entries',
                        style: const TextStyle(
                          color: Color(0xFF16834A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Products and Prices',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (shopPrices.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        'No price details available.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...shopPrices.map((item) {
                    final matchingProducts =
                        provider.products.where(
                      (product) =>
                          product.id == item.productId,
                    );

                    final product = matchingProducts.isNotEmpty
                        ? matchingProducts.first
                        : null;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(14),

                        leading: Text(
                          product?.emoji ?? '🛒',
                          style: const TextStyle(fontSize: 30),
                        ),

                        title: Text(
                          product?.name ?? 'Unknown Product',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          product?.unit ?? '',
                        ),

                        trailing: Text(
                          '₹${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF16834A),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}