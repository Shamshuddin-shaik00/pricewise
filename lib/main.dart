import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/price_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PriceProvider()..loadData(),
      child: const PriceWiseApp(),
    ),
  );
}

class PriceWiseApp extends StatelessWidget {
  const PriceWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PriceWise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16834A),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}