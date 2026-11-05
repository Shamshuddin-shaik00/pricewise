import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/price_provider.dart';

class AddPriceScreen extends StatefulWidget {
  const AddPriceScreen({super.key});

  @override
  State<AddPriceScreen> createState() => _AddPriceScreenState();
}

class _AddPriceScreenState extends State<AddPriceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController shopController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String selectedProduct = 'Milk';

  final Map<String, String> products = {
    'Milk': '1',
    'Rice': '2',
    'Tomato': '3',
    'Apple': '4',
  };

  @override
  void dispose() {
    shopController.dispose();
    locationController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void submitPrice() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price = double.parse(priceController.text.trim());

    // Add the submitted price to Provider.
    Provider.of<PriceProvider>(context, listen: false).addShopPrice(
      productId: products[selectedProduct]!,
      shopName: shopController.text.trim(),
      area: locationController.text.trim(),
      price: price,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Price added successfully!'),
        backgroundColor: Color(0xFF16834A),
      ),
    );

    shopController.clear();
    locationController.clear();
    priceController.clear();

    setState(() {
      selectedProduct = 'Milk';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text(
          'Add Product Price',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share Local Shop Prices',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help others find the best prices in their area.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),

              const Text(
                'Select Product',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedProduct,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: products.keys.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedProduct = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Shop Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: shopController,
                decoration: InputDecoration(
                  hintText: 'Enter shop name',
                  prefixIcon: const Icon(Icons.store),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter shop name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Shop Location',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Enter shop area',
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter shop location';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Product Price (₹)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter price',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  final price = double.tryParse(value?.trim() ?? '');

                  if (price == null ||
                      !price.isFinite ||
                      price <= 0) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: submitPrice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16834A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}