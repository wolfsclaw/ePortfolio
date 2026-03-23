// Artifact Two: Low-Stock Prioritization Algorithm
// ------------------------------------------------
// This stand-alone Dart program demonstrates algorithmic thinking by
// filtering, ranking, and prioritizing inventory items based on how
// urgently they need to be reordered.

class Item {
  final String name;
  final int quantity;
  final int lowStockThreshold;

  Item({
    required this.name,
    required this.quantity,
    required this.lowStockThreshold,
  });

  // A computed metric that represents how "urgent" the item is.
  // Lower ratios mean more urgent (e.g., 2/10 = 0.2 is worse than 8/10 = 0.8).
  double get urgencyRatio {
    if (lowStockThreshold == 0) return double.infinity;
    return quantity / lowStockThreshold;
  }

  @override
  String toString() {
    return "$name (qty: $quantity, threshold: $lowStockThreshold, urgency: ${urgencyRatio.toStringAsFixed(2)})";
  }
}

/// Returns a prioritized list of items that are at or below their
/// low-stock threshold, sorted by urgency.
///
/// Steps:
/// 1. Filter items that need restocking.
/// 2. Sort them by urgency ratio (ascending).
/// 3. Return the prioritized list.
List<Item> getReorderPriority(List<Item> items) {
  // Step 1: Filter items that are low or critically low.
  final lowStockItems = items.where((item) {
    return item.quantity <= item.lowStockThreshold;
  }).toList();

  // Step 2: Sort by urgency ratio (lower = more urgent).
  lowStockItems.sort((a, b) => a.urgencyRatio.compareTo(b.urgencyRatio));

  return lowStockItems;
}

void main() {
  // Example dataset for demonstration.
  final inventory = [
    Item(name: "Printer Paper", quantity: 20, lowStockThreshold: 50),
    Item(name: "Ink Cartridges", quantity: 5, lowStockThreshold: 10),
    Item(name: "Staples", quantity: 200, lowStockThreshold: 100),
    Item(name: "Shipping Labels", quantity: 8, lowStockThreshold: 20),
    Item(name: "Bubble Wrap", quantity: 2, lowStockThreshold: 15),
  ];

  print("=== Full Inventory ===");
  inventory.forEach(print);

  print("\n=== Reorder Priority List ===");
  final priorityList = getReorderPriority(inventory);
  priorityList.forEach(print);
}

