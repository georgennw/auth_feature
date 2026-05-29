class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(value)) {
      return 'Invalid email format';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8 || value.length > 24) {
      return 'Password must be 8-24 characters';
    }

    final hasUpper = value.contains(RegExp(r'[A-Z]'));
    final hasLower = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'\d'));
    final hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUpper) {
      return 'Password needs an uppercase letter';
    }

    if (!hasLower) {
      return 'Password needs a lowercase letter';
    }

    if (!hasDigit) {
      return 'Password needs a digit';
    }

    if (!hasSpecial) {
      return 'Password needs a special character';
    }

    return null;
  }

  static String? repeatPassword(String? password, String? repeat) {
    if (repeat == null || repeat.isEmpty) {
      return 'Repeat password is required';
    }

    if (password != repeat) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}
