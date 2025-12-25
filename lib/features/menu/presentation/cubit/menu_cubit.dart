import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial()) {
    _initialize();
  }

  void _initialize() {
    emit(
      MenuLoaded(
        selectedCategoryId: '1', // Default to "All"
        selectedMenuType: 'Normal Menu', // Default menu type
        selectedItemIds: {},
        lastUpdated: DateTime.now(),
        menuItems: List.from(MenuMockData.menuItems),
        categories: List.from(MenuMockData.categories),
      ),
    );
  }

  void selectCategory(String categoryId) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      emit(
        currentState.copyWith(
          selectedCategoryId: categoryId,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void selectMenuType(String menuType) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      emit(
        currentState.copyWith(
          selectedMenuType: menuType,
          lastUpdated: DateTime.now(),
        ),
      );
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
      final currentState = state as MenuLoaded;
      emit(
        currentState.copyWith(selectedItemIds: {}, lastUpdated: DateTime.now()),
      );
    }
  }

  void selectAllItems(List<String> itemIds) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      emit(
        currentState.copyWith(
          selectedItemIds: Set<String>.from(itemIds),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  // Force refresh the UI by re-loading data from mock
  void refresh() {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      emit(
        currentState.copyWith(
          lastUpdated: DateTime.now(),
          menuItems: List.from(MenuMockData.menuItems),
          categories: List.from(MenuMockData.categories),
        ),
      );
    }
  }
}
