import 'package:mrpos/features/menu/domain/models/menu_models.dart';

abstract class MenuRepository {
  // Menu Items
  Stream<List<MenuItem>> getMenuItems();
  Future<void> addMenuItem(MenuItem item);
  Future<void> updateMenuItem(MenuItem item);
  Future<void> deleteMenuItem(String id);

  // Categories
  Stream<List<MenuCategory>> getCategories();
  Future<void> addCategory(MenuCategory category);
  Future<void> updateCategory(MenuCategory category);
  Future<void> deleteCategory(String id);

  // Menu Types
  Stream<List<MenuType>> getMenuTypes();
  Future<void> addMenuType(MenuType menuType);
  Future<void> updateMenuType(MenuType menuType);
  Future<void> deleteMenuType(String id);
}
