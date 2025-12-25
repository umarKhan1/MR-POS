import 'package:equatable/equatable.dart';

/// Represents a menu type (e.g., Normal Menu, Special Deals, etc.)
/// This will be loaded from Firebase in the future
class MenuType extends Equatable {
  final String id;
  final String name;
  final int displayOrder;

  const MenuType({
    required this.id,
    required this.name,
    required this.displayOrder,
  });

  @override
  List<Object?> get props => [id, name, displayOrder];

  // Mock data - will be replaced with Firebase
  static const List<MenuType> mockMenuTypes = [
    MenuType(id: '1', name: 'Normal Menu', displayOrder: 1),
    MenuType(id: '2', name: 'Special Deals', displayOrder: 2),
    MenuType(id: '3', name: 'New Year Special', displayOrder: 3),
    MenuType(id: '4', name: 'Deserts and Drinks', displayOrder: 4),
  ];
}
