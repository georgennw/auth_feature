abstract class ValidationConstants {
  ValidationConstants._();

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 24;
}

abstract class ValidationRegex {
  ValidationRegex._();

  static final RegExp email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp uppercase = RegExp(r'[A-Z]');
  static final RegExp lowercase = RegExp(r'[a-z]');
  static final RegExp digit = RegExp(r'\d');
  static final RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
}
