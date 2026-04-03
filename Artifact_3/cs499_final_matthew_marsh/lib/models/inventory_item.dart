/// InventoryItem represents a single item stored in the inventory system.
/// This model is used throughout the app for displaying, editing, and
/// storing item data in Firestore.
class InventoryItem {
  final String id;                // Firestore document ID
  final String name;              // Name of the item
  final int quantity;             // Current quantity in stock
  final int lowStockThreshold;    // Threshold for low-stock warning
  final String location;          // Physical storage location
  final String category;          // Category or type of item

  /// Constructor for creating an InventoryItem object.
  /// The [id] is assigned by Firestore when adding a new item.
  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.lowStockThreshold,
    required this.location,
    required this.category,
  });

  /// Factory constructor that creates an InventoryItem from Firestore data.
  /// [id] is the Firestore document ID.
  /// [data] is the map of fields stored in the document.
  factory InventoryItem.fromFirestore(String id, Map<String, dynamic> data) {
    return InventoryItem(
      id: id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      lowStockThreshold: data['lowStockThreshold'] ?? 0,
      location: data['location'] ?? '',
      category: data['category'] ?? '',
    );
  }

  /// Converts the InventoryItem into a map format for Firestore.
  /// The [id] is not included because Firestore manages document IDs separately.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'lowStockThreshold': lowStockThreshold,
      'location': location,
      'category': category,
    };
  }
}

