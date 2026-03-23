import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';

/// AddItemPage allows the user to create a new inventory item.
/// This screen collects form input, validates it, and sends the
/// new item to Firestore through the FirestoreService.
class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  // Global key used to validate the form fields.
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field.
  // These allow reading and clearing text values.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController lowStockController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // Firestore service handles database operations.
  final FirestoreService _firestoreService = FirestoreService();

  /// Saves the item to Firestore after validating the form.
  Future<void> _saveItem() async {
    // If validation fails, stop the save process.
    if (!_formKey.currentState!.validate()) return;

    // Create a new InventoryItem object from form input.
    // Firestore will generate the document ID automatically.
    final newItem = InventoryItem(
      id: '',
      name: nameController.text.trim(),
      quantity: int.parse(quantityController.text),
      lowStockThreshold: int.parse(lowStockController.text),
      location: locationController.text.trim(),
      category: categoryController.text.trim(),
    );

    // Add the item to Firestore.
    await _firestoreService.addItem(newItem);

    // Only navigate back if the widget is still mounted.
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title for the page.
      appBar: AppBar(title: const Text("Add Item")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // Form widget enables validation and structured input.
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              // Item name input
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 12),

              // Quantity input
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter quantity" : null,
              ),
              const SizedBox(height: 12),

              // Low stock threshold input
              TextFormField(
                controller: lowStockController,
                decoration:
                const InputDecoration(labelText: "Low Stock Threshold"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter threshold" : null,
              ),
              const SizedBox(height: 12),

              // Location input (optional)
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 12),

              // Category input (optional)
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),

              // Save button triggers form validation and Firestore write.
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text("Save Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

