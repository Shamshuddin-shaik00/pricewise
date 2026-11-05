import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/shop_price.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Create or open the database.
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'pricewise.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Create database tables.
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shop_prices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL,
        shopName TEXT NOT NULL,
        area TEXT NOT NULL,
        price REAL NOT NULL,
        submittedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        productId TEXT PRIMARY KEY
      )
    ''');
  }

  // Save a shop price.
  Future<int> insertShopPrice(ShopPrice shopPrice) async {
    final db = await database;

    return await db.insert(
      'shop_prices',
      {
        'productId': shopPrice.productId,
        'shopName': shopPrice.shopName,
        'area': shopPrice.area,
        'price': shopPrice.price,
        'submittedAt': shopPrice.submittedAt.toIso8601String(),
      },
    );
  }

  // Get all saved shop prices.
  Future<List<ShopPrice>> getShopPrices() async {
    final db = await database;

    final result = await db.query(
      'shop_prices',
      orderBy: 'submittedAt DESC',
    );

    return result.map((item) {
      return ShopPrice(
        productId: item['productId'] as String,
        shopName: item['shopName'] as String,
        area: item['area'] as String,
        price: (item['price'] as num).toDouble(),
        submittedAt: DateTime.parse(
          item['submittedAt'] as String,
        ),
      );
    }).toList();
  }

  // Save favourite product IDs.
  Future<void> saveFavorites(Set<String> productIds) async {
    final db = await database;

    await db.transaction((transaction) async {
      await transaction.delete('favorites');

      for (final productId in productIds) {
        await transaction.insert(
          'favorites',
          {'productId': productId},
        );
      }
    });
  }

  // Load favourite product IDs.
  Future<Set<String>> getFavorites() async {
    final db = await database;

    final result = await db.query('favorites');

    return result
        .map((item) => item['productId'] as String)
        .toSet();
  }
}