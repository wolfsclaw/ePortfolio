import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';
import 'edit_item_page.dart';
import 'add_item_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// InventoryListPage displays all inventory items in real time.
/// Users can filter low-stock items, add new items, edit existing ones,
/// and delete items with a long press.
///
/// UI has been upgraded to match the polished style guide:
/// - Rounded cards
/// - Icons for clarity
/// - Improved spacing & typography
/// - Low-stock warning icon
/// - Modern FAB
/// - Optional micro-animations
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  final FirestoreService _firestoreService = FirestoreService();

  bool showLowStockOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Polished AppBar
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      // Modern Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddItemPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Item", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Low-stock toggle
            Row(
              children: [
                const Text("Show low-stock only"),
                Switch(
                  value: showLowStockOnly,
                  onChanged: (value) {
                    setState(() {
                      showLowStockOnly = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Real-time inventory list
            Expanded(
              child: StreamBuilder<List<InventoryItem>>(
                stream: _firestoreService.getItems(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<InventoryItem> items = snapshot.data!;

                  // Apply low-stock filter
                  if (showLowStockOnly) {
                    items = items
                        .where((item) =>
                    item.quantity <= item.lowStockThreshold)
                        .toList();
                  }

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        "No items found.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _animatedItemCard(context, items[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Polished Animated Card Wrapper (smooth fade + slide)

  Widget _animatedItemCard(BuildContext context, InventoryItem item) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildItemCard(context, item),
    );
  }

  // Polished Item Card UI

  Widget _buildItemCard(BuildContext context, InventoryItem item) {
    final bool isLowStock = item.quantity <= item.lowStockThreshold;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditItemPage(item: item),
          ),
        );
      },
      onLongPress: () {
        _showDeleteDialog(context, item);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Leading icon
              Icon(
                Icons.inventory_2,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(width: 16),

              // Item name + quantity/location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: isLowStock
                            ? Theme.of(context).colorScheme.error
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.numbers,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Qty: ${item.quantity} • ${item.location}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Low-stock warning icon
              if (isLowStock)
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete Confirmation Dialog (Polished Modern UI)

  void _showDeleteDialog(BuildContext context, InventoryItem item) {
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
                "Are you sure you want to delete '${item.name}'? "
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
                        await _firestoreService.deleteItem(item.id);
                        if (context.mounted) Navigator.pop(context);
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
}