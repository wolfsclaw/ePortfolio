import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventory_item.dart';

/// FirestoreService provides a clean abstraction layer for all Firestore
/// operations related to inventory items. This keeps database logic separate
/// from UI code and supports a modular, maintainable architecture.
class FirestoreService {
  // Reference to the "inventory" collection in Firestore.
  // Each document in this collection represents a single InventoryItem.
  final CollectionReference items =
  FirebaseFirestore.instance.collection('inventory');

  /// Returns a real-time stream of all inventory items.
  ///
  /// Firestore's snapshot stream emits updates whenever data changes,
  /// allowing the UI to automatically refresh without manual reloads.
  Stream<List<InventoryItem>> getItems() {
    return items.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Convert Firestore document into an InventoryItem model.
        return InventoryItem.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  /// Adds a new inventory item to Firestore.
  ///
  /// Firestore automatically generates a unique document ID.
  Future<void> addItem(InventoryItem item) {
    return items.add(item.toMap());
  }

  /// Updates an existing inventory item in Firestore.
  ///
  /// The item's ID determines which document is updated.
  Future<void> updateItem(InventoryItem item) {
    return items.doc(item.id).update(item.toMap());
  }

  /// Deletes an inventory item from Firestore using its document ID.
  Future<void> deleteItem(String id) {
    return items.doc(id).delete();
  }
}