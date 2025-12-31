import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/domain/repositories/menu_repository.dart';

class FirestoreMenuRepository implements MenuRepository {
  final FirebaseFirestore _firestore;

  FirestoreMenuRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // --- Menu Items ---

  @override
  Stream<List<MenuItem>> getMenuItems() {
    return _firestore
        .collection('menu_items')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<void> addMenuItem(MenuItem item) async {
    await _firestore
        .collection('menu_items')
        .add(item.toFirestore())
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> updateMenuItem(MenuItem item) async {
    await _firestore
        .collection('menu_items')
        .doc(item.id)
        .update(item.toFirestore())
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> deleteMenuItem(String id) async {
    await _firestore
        .collection('menu_items')
        .doc(id)
        .delete()
        .timeout(const Duration(seconds: 10));
  }

  // --- Categories ---

  @override
  Stream<List<MenuCategory>> getCategories() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MenuCategory.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> addCategory(MenuCategory category) async {
    await _firestore
        .collection('categories')
        .add(category.toFirestore())
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> updateCategory(MenuCategory category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toFirestore())
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _firestore
        .collection('categories')
        .doc(id)
        .delete()
        .timeout(const Duration(seconds: 10));
  }

  // --- Menu Types ---

  @override
  Stream<List<MenuType>> getMenuTypes() {
    return _firestore
        .collection('menu_types')
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => MenuType.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<void> addMenuType(MenuType menuType) async {
    await _firestore
        .collection('menu_types')
        .add(menuType.toFirestore())
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> updateMenuType(MenuType menuType) async {
    await _firestore
        .collection('menu_types')
        .doc(menuType.id)
        .update(menuType.toFirestore())
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> deleteMenuType(String id) async {
    await _firestore
        .collection('menu_types')
        .doc(id)
        .delete()
        .timeout(const Duration(seconds: 10));
  }
}
