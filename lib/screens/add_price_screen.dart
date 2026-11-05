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

  final TextEditingController shopController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  final Map<String, String> products = {
    'Milk': '1',
    'Rice': '2',
    'Tomato': '3',
    'Apple': '4',
  };

  String selectedProduct = 'Milk';

  bool isSaving = false;

  Future<void> submitPrice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final price = double.parse(priceController.text.trim());

    try {
      await Provider.of<PriceProvider>(
        context,
        listen: false,
      ).addShopPrice(
        productId: products[selectedProduct]!,
        shopName: shopController.text.trim(),
        area: locationController.text.trim(),
        price: price,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price saved successfully!'),
          backgroundColor: Color(0xFF16834A),
        ),
      );

      shopController.clear();
      locationController.clear();
      priceController.clear();

      setState(() {
        selectedProduct = 'Milk';
        isSaving = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save price. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    shopController.dispose();
    locationController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Shop Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF16834A),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Center(
                child: Icon(
                  Icons.storefront,
                  size: 70,
                  color: Color(0xFF16834A),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Share a Local Shop Price',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Product dropdown
              const Text(
                'Select Product',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedProduct,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: products.keys.map((product) {
                  return DropdownMenuItem<String>(
                    value: product,
                    child: Text(product),
                  );
                }).toList(),
                onChanged: isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            selectedProduct = value;
                          });
                        }
                      },
              ),

              const SizedBox(height: 20),

              // Shop name
              const Text(
                'Shop Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: shopController,
                enabled: !isSaving,
                decoration: InputDecoration(
                  hintText: 'Enter shop name',
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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

              // Location
              const Text(
                'Shop Location / Area',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: locationController,
                enabled: !isSaving,
                decoration: InputDecoration(
                  hintText: 'Example: Guntur, Main Road',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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

              // Price
              const Text(
                'Product Price (₹)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: priceController,
                enabled: !isSaving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter product price',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }

                  final price = double.tryParse(value.trim());

                  if (price == null ||
                      !price.isFinite ||
                      price <= 0) {
                    return 'Enter a valid price greater than zero';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : submitPrice,
                  icon: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    isSaving ? 'Saving...' : 'Save Price',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16834A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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