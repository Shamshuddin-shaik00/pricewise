import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductComparisonScreen extends StatelessWidget {
  final Product product;

  const ProductComparisonScreen({
    super.key,
    required this.product,
  });

  List<Map<String, dynamic>> get shopPrices {
    switch (product.id) {
      case '1':
        return [
          {'shop': 'Sri Lakshmi Stores', 'area': 'Main Road', 'price': 30.0},
          {'shop': 'Fresh Mart', 'area': 'NTR Colony', 'price': 28.0},
          {'shop': 'Daily Needs', 'area': 'Market Road', 'price': 32.0},
        ];
      case '2':
        return [
          {'shop': 'Sri Lakshmi Stores', 'area': 'Main Road', 'price': 52.0},
          {'shop': 'Fresh Mart', 'area': 'NTR Colony', 'price': 48.0},
          {'shop': 'Daily Needs', 'area': 'Market Road', 'price': 50.0},
        ];
      case '3':
        return [
          {'shop': 'Sri Lakshmi Stores', 'area': 'Main Road', 'price': 30.0},
          {'shop': 'Fresh Mart', 'area': 'NTR Colony', 'price': 25.0},
          {'shop': 'Daily Needs', 'area': 'Market Road', 'price': 28.0},
        ];
      default:
        return [
          {'shop': 'Sri Lakshmi Stores', 'area': 'Main Road', 'price': 125.0},
          {'shop': 'Fresh Mart', 'area': 'NTR Colony', 'price': 120.0},
          {'shop': 'Daily Needs', 'area': 'Market Road', 'price': 130.0},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final shops = [...shopPrices]
      ..sort((a, b) =>
          (a['price'] as double).compareTo(b['price'] as double));

    final cheapestPrice = shops.first['price'] as double;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Price Comparison'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 35),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(product.unit),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Shop Prices',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  final price = shop['price'] as double;
                  final isCheapest = price == cheapestPrice;

                  return Card(
                    color: isCheapest
                        ? const Color(0xFFE5F5E9)
                        : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFDDF2E3),
                        child: Icon(
                          Icons.store,
                          color: Color(0xFF16834A),
                        ),
                      ),
                      title: Text(
                        shop['shop'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(shop['area'] as String),
                          if (isCheapest)
                            const Text(
                              'CHEAPEST SHOP',
                              style: TextStyle(
                                color: Color(0xFF16834A),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                      trailing: Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: isCheapest
                              ? const Color(0xFF16834A)
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}