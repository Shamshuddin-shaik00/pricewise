import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/shop_price.dart';
import '../services/database_helper.dart';

class PriceProvider extends ChangeNotifier {
  String searchQuery = '';
  String selectedCategory = 'All';

  // Favourite product IDs
  final Set<String> favoriteProductIds = {};

  // Product list
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Milk',
      category: 'Dairy',
      unit: '1 Litre',
      lowestPrice: 28,
      shopCount: 4,
      emoji: '🥛',
    ),
    Product(
      id: '2',
      name: 'Rice',
      category: 'Groceries',
      unit: '1 Kg',
      lowestPrice: 48,
      shopCount: 5,
      emoji: '🍚',
    ),
    Product(
      id: '3',
      name: 'Tomato',
      category: 'Vegetables',
      unit: '1 Kg',
      lowestPrice: 25,
      shopCount: 3,
      emoji: '🍅',
    ),
    Product(
      id: '4',
      name: 'Apple',
      category: 'Fruits',
      unit: '1 Kg',
      lowestPrice: 120,
      shopCount: 4,
      emoji: '🍎',
    ),
  ];

  // Shop prices loaded from SQLite
  final List<ShopPrice> shopPrices = [];

  bool isLoading = true;

  // Load saved prices and favourites
  Future<void> loadData() async {
    try {
      final savedPrices =
          await DatabaseHelper.instance.getShopPrices();

      final savedFavorites =
          await DatabaseHelper.instance.getFavorites();

      shopPrices
        ..clear()
        ..addAll(savedPrices);

      favoriteProductIds
        ..clear()
        ..addAll(savedFavorites);
    } catch (error) {
      debugPrint('Database loading error: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Filter products by search and category
  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' ||
          product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Update search
  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  // Update category
  void updateCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  // Add a shop price and save it permanently
  Future<void> addShopPrice({
    required String productId,
    required String shopName,
    required String area,
    required double price,
  }) async {
    final newPrice = ShopPrice(
      productId: productId,
      shopName: shopName,
      area: area,
      price: price,
      submittedAt: DateTime.now(),
    );

    // Save to SQLite first
    await DatabaseHelper.instance.insertShopPrice(newPrice);

    // Update app after successful saving
    shopPrices.add(newPrice);
    notifyListeners();
  }

  // Get prices for a product (lowest first)
  List<ShopPrice> getPricesForProduct(String productId) {
    return shopPrices
        .where((item) => item.productId == productId)
        .toList()
      ..sort((a, b) => a.price.compareTo(b.price));
  }

  // Get unique shop count for a product
  int getShopCountForProduct(String productId) {
    final uniqueShops = shopPrices
        .where((item) => item.productId == productId)
        .map((item) => item.shopName.trim().toLowerCase())
        .toSet();

    return uniqueShops.length;
  }

  // Check whether a product is a favourite
  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

  // Add or remove favourite and save permanently
  Future<void> toggleFavorite(String productId) async {
    final updatedFavorites =
        Set<String>.from(favoriteProductIds);

    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    // Save updated favourites first
    await DatabaseHelper.instance.saveFavorites(
      updatedFavorites,
    );

    // Update app after successful saving
    favoriteProductIds
      ..clear()
      ..addAll(updatedFavorites);

    notifyListeners();
  }

  // Get all favourite products
  List<Product> get favoriteProducts {
    return products
        .where(
          (product) =>
              favoriteProductIds.contains(product.id),
        )
        .toList();
  }
}