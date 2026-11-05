import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pricewise/providers/price_provider.dart';
import 'package:pricewise/screens/home_screen.dart';

void main() {
  testWidgets('Home screen displays products', (tester) async {
    final provider = PriceProvider();

    provider.isLoading = false;

    await tester.pumpWidget(
      ChangeNotifierProvider<PriceProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('PriceWise'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Tomato'), findsOneWidget);
    expect(find.text('Add Price'), findsOneWidget);

    // Scroll down to find Apple.
    await tester.scrollUntilVisible(
      find.text('Apple'),
      300,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Apple'), findsOneWidget);
  });
}