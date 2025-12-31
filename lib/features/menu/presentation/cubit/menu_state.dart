import 'package:equatable/equatable.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final String selectedCategoryId;
  final String selectedMenuType;
  final Set<String> selectedItemIds;
  final DateTime lastUpdated;
  final List<MenuItem> menuItems;
  final List<MenuCategory> categories;
  final List<MenuType> menuTypes;

  const MenuLoaded({
    required this.selectedCategoryId,
    required this.selectedMenuType,
    required this.selectedItemIds,
    required this.lastUpdated,
    required this.menuItems,
    required this.categories,
    required this.menuTypes,
  });

  MenuLoaded copyWith({
    String? selectedCategoryId,
    String? selectedMenuType,
    Set<String>? selectedItemIds,
    DateTime? lastUpdated,
    List<MenuItem>? menuItems,
    List<MenuCategory>? categories,
    List<MenuType>? menuTypes,
  }) {
    return MenuLoaded(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedMenuType: selectedMenuType ?? this.selectedMenuType,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      menuItems: menuItems ?? this.menuItems,
      categories: categories ?? this.categories,
      menuTypes: menuTypes ?? this.menuTypes,
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
    menuTypes,
  ];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object?> get props => [message];
}
