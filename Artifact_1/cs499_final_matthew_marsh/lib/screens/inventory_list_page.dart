import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';
import 'edit_item_page.dart';
import 'add_item_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// InventoryListPage displays all inventory items in real time.
/// Users can filter low-stock items, add new items, edit existing ones,
/// and delete items with a long press.
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  // Firestore service handles all database interactions.
  final FirestoreService _firestoreService = FirestoreService();

  // Controls whether the list shows all items or only low-stock items.
  bool showLowStockOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with logout button
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Signs the user out of Firebase Authentication
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      // Floating button to navigate to Add Item page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddItemPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // Toggle switch for low-stock filtering
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text("Show low-stock only"),
                Switch(
                  value: showLowStockOnly,
                  onChanged: (value) {
                    // Rebuild UI when filter changes
                    setState(() {
                      showLowStockOnly = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Main list area
          Expanded(
            child: StreamBuilder<List<InventoryItem>>(
              // Real-time Firestore stream of inventory items
              stream: _firestoreService.getItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // Show loading indicator while waiting for data
                  return const Center(child: CircularProgressIndicator());
                }

                // Extract items from snapshot
                List<InventoryItem> items = snapshot.data!;

                // Apply low-stock filter if enabled
                if (showLowStockOnly) {
                  items = items
                      .where((item) =>
                  item.quantity <= item.lowStockThreshold)
                      .toList();
                }

                // Display message if no items match the filter
                if (items.isEmpty) {
                  return const Center(
                    child: Text("No items found."),
                  );
                }

                // Build scrollable list of inventory cards
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isLowStock =
                        item.quantity <= item.lowStockThreshold;

                    return Card(
                      child: ListTile(
                        // Item name with red highlight if low stock
                        title: Text(
                          item.name,
                          style: TextStyle(
                            color: isLowStock ? Colors.red : Colors.black,
                            fontWeight: isLowStock
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),

                        // Quantity and location display
                        subtitle: Text(
                          "Qty: ${item.quantity} • Location: ${item.location}",
                        ),

                        // Warning icon for low-stock items
                        trailing: isLowStock
                            ? const Icon(Icons.warning, color: Colors.red)
                            : null,

                        // Tap to edit item
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditItemPage(item: item),
                            ),
                          );
                        },

                        // Long press to delete item with confirmation dialog
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Item"),
                              content: Text(
                                  "Are you sure you want to delete '${item.name}'?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Delete item from Firestore
                                    await _firestoreService.deleteItem(item.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

