import 'package:equatable/equatable.dart';
import 'package:mrpos/core/constants/mock_data.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoaded extends MenuState {
  final String selectedCategoryId;
  final String selectedMenuType; // Changed from selectedTabIndex
  final Set<String> selectedItemIds;
  final DateTime lastUpdated;
  final List<MenuItem> menuItems;
  final List<MenuCategory> categories;

  const MenuLoaded({
    required this.selectedCategoryId,
    required this.selectedMenuType,
    required this.selectedItemIds,
    required this.lastUpdated,
    required this.menuItems,
    required this.categories,
  });

  MenuLoaded copyWith({
    String? selectedCategoryId,
    String? selectedMenuType,
    Set<String>? selectedItemIds,
    DateTime? lastUpdated,
    List<MenuItem>? menuItems,
    List<MenuCategory>? categories,
  }) {
    return MenuLoaded(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedMenuType: selectedMenuType ?? this.selectedMenuType,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      menuItems: menuItems ?? this.menuItems,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategoryId,
    selectedMenuType,
    selectedItemIds,
    lastUpdated,
    menuItems,
    categories,
  ];
}
