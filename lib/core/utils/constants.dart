abstract class ValidationConstants {
  ValidationConstants._();

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 24;
  static const int maxUsernameLength = 14;
  static const int minAge = 14;
}

abstract class ValidationRegex {
  ValidationRegex._();

  static final RegExp email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp uppercase = RegExp('[A-Z]');
  static final RegExp lowercase = RegExp('[a-z]');
  static final RegExp digit = RegExp(r'\d');
  static final RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
}
