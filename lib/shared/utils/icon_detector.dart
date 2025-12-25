import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Utility class to detect and return appropriate icons based on category names
/// This avoids Firebase Storage costs by using built-in icons
class IconDetector {
  /// Detects the appropriate icon based on category name keywords
  static IconData detectIcon(String categoryName) {
    final name = categoryName.toLowerCase().trim();

    // Pizza
    if (name.contains('pizza')) {
      return FontAwesomeIcons.pizzaSlice;
    }

    // Burgers & Fast Food
    if (name.contains('burger') ||
        name.contains('fast food') ||
        name.contains('fastfood')) {
      return FontAwesomeIcons.burger;
    }

    // Chicken
    if (name.contains('chicken') ||
        name.contains('drumstick') ||
        name.contains('poultry')) {
      return FontAwesomeIcons.drumstickBite;
    }

    // Seafood
    if (name.contains('seafood') ||
        name.contains('fish') ||
        name.contains('shrimp') ||
        name.contains('lobster')) {
      return FontAwesomeIcons.fish;
    }

    // Bakery
    if (name.contains('bakery') ||
        name.contains('bread') ||
        name.contains('bake')) {
      return FontAwesomeIcons.breadSlice;
    }

    // Beverages
    if (name.contains('beverage') ||
        name.contains('drink') ||
        name.contains('juice') ||
        name.contains('soda')) {
      return FontAwesomeIcons.wineGlass;
    }

    // Desserts
    if (name.contains('dessert') ||
        name.contains('sweet') ||
        name.contains('ice cream') ||
        name.contains('cake')) {
      return FontAwesomeIcons.iceCream;
    }

    // Salad & Vegetables
    if (name.contains('salad') ||
        name.contains('vegetable') ||
        name.contains('veg') ||
        name.contains('green')) {
      return FontAwesomeIcons.leaf;
    }

    // Pasta & Noodles
    if (name.contains('pasta') ||
        name.contains('noodle') ||
        name.contains('spaghetti')) {
      return FontAwesomeIcons.bowlFood;
    }

    // Coffee & Tea
    if (name.contains('coffee') ||
        name.contains('tea') ||
        name.contains('cafe')) {
      return FontAwesomeIcons.mugHot;
    }

    // Steak & Meat
    if (name.contains('steak') ||
        name.contains('meat') ||
        name.contains('beef')) {
      return FontAwesomeIcons.bacon;
    }

    // Default icon for unrecognized categories
    return FontAwesomeIcons.utensils;
  }

  /// Gets a readable icon key for storing in Firebase
  static String getIconKey(String categoryName) {
    final name = categoryName.toLowerCase().trim();

    if (name.contains('pizza')) return 'pizza';
    if (name.contains('burger') || name.contains('fast food')) return 'burger';
    if (name.contains('chicken')) return 'chicken';
    if (name.contains('seafood') || name.contains('fish')) return 'seafood';
    if (name.contains('bakery') || name.contains('bread')) return 'bakery';
    if (name.contains('beverage') || name.contains('drink')) return 'beverage';
    if (name.contains('dessert') || name.contains('sweet')) return 'dessert';
    if (name.contains('salad') || name.contains('vegetable')) return 'salad';
    if (name.contains('pasta') || name.contains('noodle')) return 'pasta';
    if (name.contains('coffee') || name.contains('tea')) return 'coffee';
    if (name.contains('steak') || name.contains('meat')) return 'steak';

    return 'default';
  }
}
