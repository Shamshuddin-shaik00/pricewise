import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/price_provider.dart';

class PriceHistoryScreen extends StatelessWidget {
  const PriceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text(
          'Price History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),

      body: Consumer<PriceProvider>(
        builder: (context, provider, child) {
          // Copy and sort prices by newest submission first.
          final history = [...provider.shopPrices]
            ..sort(
              (a, b) => b.submittedAt.compareTo(a.submittedAt),
            );

          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No Price History Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Submit a product price to see it here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              // Find product name using product ID.
              final matchingProducts = provider.products.where(
                (product) => product.id == item.productId,
              );

              final productName = matchingProducts.isNotEmpty
                  ? matchingProducts.first.name
                  : 'Unknown Product';

              final date = item.submittedAt;

              final formattedDate =
                  '${date.day.toString().padLeft(2, '0')}/'
                  '${date.month.toString().padLeft(2, '0')}/'
                  '${date.year}';

              final formattedTime =
                  '${date.hour.toString().padLeft(2, '0')}:'
                  '${date.minute.toString().padLeft(2, '0')}';

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),

                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE5F5E9),
                    child: Icon(
                      Icons.history,
                      color: Color(0xFF16834A),
                    ),
                  ),

                  title: Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shop: ${item.shopName}'),
                        Text('Location: ${item.area}'),
                        const SizedBox(height: 5),
                        Text(
                          '$formattedDate at $formattedTime',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  trailing: Text(
                    '₹${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF16834A),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}