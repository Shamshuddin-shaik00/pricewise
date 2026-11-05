import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/price_provider.dart';
import 'shop_details_screen.dart';

class ComparisonScreen extends StatelessWidget {
  final Product product;

  const ComparisonScreen({
    super.key,
    required this.product,
  });

  List<Map<String, dynamic>> get demoPrices {
    switch (product.id) {
      case '1':
        return [
          {
            'shop': 'Sri Lakshmi Stores',
            'area': 'Main Road',
            'price': 30.0,
          },
          {
            'shop': 'Fresh Mart',
            'area': 'NTR Colony',
            'price': 28.0,
          },
          {
            'shop': 'Daily Needs',
            'area': 'Market Road',
            'price': 32.0,
          },
        ];

      case '2':
        return [
          {
            'shop': 'Sri Lakshmi Stores',
            'area': 'Main Road',
            'price': 52.0,
          },
          {
            'shop': 'Fresh Mart',
            'area': 'NTR Colony',
            'price': 48.0,
          },
          {
            'shop': 'Daily Needs',
            'area': 'Market Road',
            'price': 50.0,
          },
        ];

      case '3':
        return [
          {
            'shop': 'Sri Lakshmi Stores',
            'area': 'Main Road',
            'price': 30.0,
          },
          {
            'shop': 'Fresh Mart',
            'area': 'NTR Colony',
            'price': 25.0,
          },
          {
            'shop': 'Daily Needs',
            'area': 'Market Road',
            'price': 28.0,
          },
        ];

      default:
        return [
          {
            'shop': 'Sri Lakshmi Stores',
            'area': 'Main Road',
            'price': 125.0,
          },
          {
            'shop': 'Fresh Mart',
            'area': 'NTR Colony',
            'price': 120.0,
          },
          {
            'shop': 'Daily Needs',
            'area': 'Market Road',
            'price': 130.0,
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'Price Comparison',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),

      body: Consumer<PriceProvider>(
        builder: (context, provider, child) {
          final userPrices =
              provider.getPricesForProduct(product.id);

          final List<Map<String, dynamic>> shops;

          if (userPrices.isNotEmpty) {
            shops = userPrices.map((item) {
              return {
                'shop': item.shopName,
                'area': item.area,
                'price': item.price,
                'isUserPrice': true,
              };
            }).toList();
          } else {
            shops = demoPrices;
          }

          shops.sort(
            (a, b) => (a['price'] as double)
                .compareTo(b['price'] as double),
          );

          final cheapestPrice =
              shops.first['price'] as double;

          return Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product information
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

                const SizedBox(height: 5),

                Text(
                  userPrices.isNotEmpty
                      ? 'Prices submitted by users'
                      : 'Demo prices – sample data',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                // Shop list
                Expanded(
                  child: ListView.builder(
                    itemCount: shops.length,

                    itemBuilder: (context, index) {
                      final shop = shops[index];

                      final shopName =
                          shop['shop'] as String;

                      final area =
                          shop['area'] as String;

                      final price =
                          shop['price'] as double;

                      final isCheapest =
                          price == cheapestPrice;

                      return Card(
                        color: isCheapest
                            ? const Color(0xFFE5F5E9)
                            : Colors.white,

                        margin:
                            const EdgeInsets.only(bottom: 12),

                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShopDetailsScreen(
                                  shopName: shopName,
                                  area: area,
                                ),
                              ),
                            );
                          },

                          leading: const CircleAvatar(
                            backgroundColor:
                                Color(0xFFDDF2E3),
                            child: Icon(
                              Icons.store,
                              color: Color(0xFF16834A),
                            ),
                          ),

                          title: Text(
                            shopName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(area),

                              if (isCheapest)
                                const Text(
                                  'CHEAPEST SHOP',
                                  style: TextStyle(
                                    color: Color(0xFF16834A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),

                              const SizedBox(height: 4),

                              const Text(
                                'Tap to view shop details',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCheapest
                                      ? const Color(0xFF16834A)
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}