class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'MR-POS';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String userKey = 'user';
  static const String tokenKey = 'token';
  static const String themeKey = 'theme';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
}

class AppStrings {
  AppStrings._();

  // Authentication
  static const String helloAgain = 'Hello Again!';
  static const String welcomeBack = 'Welcome Back';
  static const String emailHint = 'Email Address';
  static const String passwordHint = 'Password';
  static const String login = 'Login';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signUp = 'Sign Up';

  // Validation Messages
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort =
      'Password must be at least 6 characters';

  // Success Messages
  static const String loginSuccess = 'Login successful!';

  // Error Messages
  static const String loginError = 'Login failed. Please try again.';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String unknownError = 'An unknown error occurred.';
}

class AppAssets {
  AppAssets._();

  // Images
  static const String logo = 'assets/images/logo.png';
}
