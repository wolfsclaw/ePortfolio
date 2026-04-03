import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';

/// EditItemPage allows the user to update an existing inventory item.
/// The form is pre-filled with the item's current values.
/// After editing, the updated item is saved back to Firestore.
///
/// UI has been upgraded to match the polished style guide:
/// - Rounded text fields
/// - Icons for clarity
/// - Improved spacing & layout
/// - Themed buttons
/// - Consistent typography
class EditItemPage extends StatefulWidget {
  final InventoryItem item;

  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  // Global key used to validate the form fields.
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field.
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

    // Pre-fill fields with existing item data.
    nameController = TextEditingController(text: widget.item.name);
    quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    lowStockController =
        TextEditingController(text: widget.item.lowStockThreshold.toString());
    locationController = TextEditingController(text: widget.item.location);
    categoryController = TextEditingController(text: widget.item.category);
  }

  /// Saves the updated item to Firestore after validating the form.
  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedItem = InventoryItem(
      id: widget.item.id,
      name: nameController.text.trim(),
      quantity: int.parse(quantityController.text),
      lowStockThreshold: int.parse(lowStockController.text),
      location: locationController.text.trim(),
      category: categoryController.text.trim(),
    );

    await _firestoreService.updateItem(updatedItem);

    if (mounted) Navigator.pop(context);
  }
  // Polished Delete Confirmation Dialog (Modern UI)

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                "Delete Item?",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Message
              Text(
                "Are you sure you want to delete '${widget.item.name}'? "
                    "This action cannot be undone.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _firestoreService.deleteItem(widget.item.id);
                        if (context.mounted) {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Leave edit page
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// Deletes the item from Firestore.
  Future<void> _deleteItem() async {
    await _firestoreService.deleteItem(widget.item.id);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Polished AppBar
      appBar: AppBar(
        title: const Text("Edit Item"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page icon
              Icon(
                Icons.edit,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 24),

              Text(
                "Update Inventory Item",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 32),

              // Item name input
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter a name" : null,
              ),
              const SizedBox(height: 16),

              // Quantity input
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter quantity" : null,
              ),
              const SizedBox(height: 16),

              // Low stock threshold input
              TextFormField(
                controller: lowStockController,
                decoration: const InputDecoration(
                  labelText: "Low Stock Threshold",
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? "Enter threshold" : null,
              ),
              const SizedBox(height: 16),

              // Location input
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              // Category input
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _updateItem,
                child: const Text("Save Changes"),
              ),

              const SizedBox(height: 12),

              // Delete button
              OutlinedButton(
                onPressed: () => _showDeleteDialog(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  "Delete Item",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
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