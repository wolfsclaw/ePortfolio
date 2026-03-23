import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';

/// EditItemPage allows the user to modify an existing inventory item.
/// The page is pre-filled with the item's current values and updates
/// the Firestore document when the user saves changes.
class EditItemPage extends StatefulWidget {
  final InventoryItem item; // The item being edited

  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  // Key used to validate the form fields.
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field.
  // These are initialized in initState() with the existing item values.
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController lowStockController;
  late TextEditingController locationController;
  late TextEditingController categoryController;

  // Firestore service handles database operations.
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    // Pre-fill form fields with the current item data.
    // This allows the user to edit existing values easily.
    nameController = TextEditingController(text: widget.item.name);
    quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    lowStockController =
        TextEditingController(text: widget.item.lowStockThreshold.toString());
    locationController = TextEditingController(text: widget.item.location);
    categoryController = TextEditingController(text: widget.item.category);
  }

  /// Updates the item in Firestore after validating the form.
  Future<void> _updateItem() async {
    // Stop if validation fails.
    if (!_formKey.currentState!.validate()) return;

    // Create a new InventoryItem object with updated values.
    // The ID stays the same so Firestore updates the correct document.
    final updatedItem = InventoryItem(
      id: widget.item.id,
      name: nameController.text.trim(),
      quantity: int.parse(quantityController.text),
      lowStockThreshold: int.parse(lowStockController.text),
      location: locationController.text.trim(),
      category: categoryController.text.trim(),
    );

    // Send updated item to Firestore.
    await _firestoreService.updateItem(updatedItem);

    // Navigate back only if the widget is still mounted.
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title for the page.
      appBar: AppBar(title: const Text("Edit Item")),

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

              // Save button triggers Firestore update.
              ElevatedButton(
                onPressed: _updateItem,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}