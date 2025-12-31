import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/domain/repositories/menu_repository.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _repository;
  StreamSubscription? _itemsSubscription;
  StreamSubscription? _categoriesSubscription;
  StreamSubscription? _typesSubscription;

  List<MenuItem> _allItems = [];
  List<MenuCategory> _allCategories = [];
  List<MenuType> _allTypes = [];

  MenuCubit(this._repository) : super(MenuInitial()) {
    _init();
  }

  void _init() {
    emit(MenuLoading());

    // Listen to Categories
    _categoriesSubscription = _repository.getCategories().listen((categories) {
      _allCategories = categories;
      _updateState();
    }, onError: (e) => emit(MenuError(e.toString())));

    // Listen to Menu Types
    _typesSubscription = _repository.getMenuTypes().listen((types) {
      _allTypes = types;
      _updateState();
    }, onError: (e) => emit(MenuError(e.toString())));

    // Listen to Menu Items
    _itemsSubscription = _repository.getMenuItems().listen((items) {
      _allItems = items;
      _updateState();
    }, onError: (e) => emit(MenuError(e.toString())));
  }

  void _updateState() {
    final currentState = state;
    String selectedCategoryId = '1'; // Default to "All"
    String selectedMenuType = 'All';
    Set<String> selectedItemIds = {};

    if (currentState is MenuLoaded) {
      selectedCategoryId = currentState.selectedCategoryId;
      selectedMenuType = currentState.selectedMenuType;
      selectedItemIds = currentState.selectedItemIds;
    }

    // Calculate item counts for each category dynamically
    final categoriesWithCounts = _allCategories.map((category) {
      final count = _allItems
          .where((item) => item.category == category.name)
          .length;
      return category.copyWith(itemCount: count);
    }).toList();

    emit(
      MenuLoaded(
        selectedCategoryId: selectedCategoryId,
        selectedMenuType: selectedMenuType,
        selectedItemIds: selectedItemIds,
        lastUpdated: DateTime.now(),
        menuItems: _allItems,
        categories: categoriesWithCounts,
        menuTypes: _allTypes,
      ),
    );
  }

  void selectCategory(String categoryId) {
    if (state is MenuLoaded) {
      emit(
        (state as MenuLoaded).copyWith(
          selectedCategoryId: categoryId,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void selectMenuType(String menuType) {
    if (state is MenuLoaded) {
      emit(
        (state as MenuLoaded).copyWith(
          selectedMenuType: menuType,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  // CRUD Operations
  Future<void> addMenuItem(MenuItem item) async {
    try {
      await _repository.addMenuItem(item);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMenuItem(MenuItem item) async {
    try {
      await _repository.updateMenuItem(item);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      await _repository.deleteMenuItem(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCategory(MenuCategory category) async {
    try {
      await _repository.addCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(MenuCategory category) async {
    try {
      await _repository.updateCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMenuType(MenuType type) async {
    try {
      await _repository.addMenuType(type);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMenuType(MenuType type) async {
    try {
      await _repository.updateMenuType(type);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMenuType(String id) async {
    try {
      await _repository.deleteMenuType(id);
    } catch (e) {
      rethrow;
    }
  }

  void toggleItemSelection(String itemId) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      final newSelectedItems = Set<String>.from(currentState.selectedItemIds);

      if (newSelectedItems.contains(itemId)) {
        newSelectedItems.remove(itemId);
      } else {
        newSelectedItems.add(itemId);
      }

      emit(
        currentState.copyWith(
          selectedItemIds: newSelectedItems,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void clearSelection() {
    if (state is MenuLoaded) {
      emit(
        (state as MenuLoaded).copyWith(
          selectedItemIds: {},
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    _typesSubscription?.cancel();
    return super.close();
  }
}
