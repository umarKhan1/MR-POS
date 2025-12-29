import 'package:flutter/material.dart';

/// Responsive breakpoints following Material Design guidelines
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Responsive utility class for handling different screen sizes
class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  /// Get screen width
  double get width => MediaQuery.of(context).size.width;

  /// Get screen height
  double get height => MediaQuery.of(context).size.height;

  /// Check if current screen is mobile
  bool get isMobile => width <= ResponsiveBreakpoints.mobile;

  /// Check if current screen is tablet
  bool get isTablet =>
      width > ResponsiveBreakpoints.mobile &&
      width <= ResponsiveBreakpoints.tablet;

  /// Check if current screen is desktop
  bool get isDesktop => width > ResponsiveBreakpoints.tablet;

  /// Check if current screen is mobile or tablet
  bool get isMobileOrTablet => width <= ResponsiveBreakpoints.tablet;

  /// Get responsive value based on screen size
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive padding
  double get padding => responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0);

  /// Get responsive card padding
  double get cardPadding =>
      responsive(mobile: 12.0, tablet: 16.0, desktop: 20.0);

  /// Get responsive spacing
  double get spacing => responsive(mobile: 12.0, tablet: 16.0, desktop: 24.0);

  /// Get responsive font size for headings
  double get headingFontSize =>
      responsive(mobile: 20.0, tablet: 24.0, desktop: 28.0);

  /// Get responsive font size for titles
  double get titleFontSize =>
      responsive(mobile: 16.0, tablet: 18.0, desktop: 20.0);

  /// Get responsive font size for body text
  double get bodyFontSize =>
      responsive(mobile: 14.0, tablet: 15.0, desktop: 16.0);
}

/// Extension on BuildContext for easy access to ResponsiveUtils
extension ResponsiveExtension on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}

/// Responsive builder widget for conditional layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveUtils responsive)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils(context));
  }
}

/// Responsive layout widget with separate builders for each screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    if (responsive.isDesktop && desktop != null) {
      return desktop!(context);
    }

    if (responsive.isTablet && tablet != null) {
      return tablet!(context);
    }

    return mobile(context);
  }
}
