import 'package:auth/core/l10n/app_localizations.dart';

class Validator {
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.errorEmailRequired;
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(value)) {
      return l10n.errorEmailInvalid;
    }

    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.errorPasswordRequired;
    }

    if (value.length < 8 || value.length > 24) {
      return l10n.errorPasswordLength;
    }

    final hasUpper = value.contains(RegExp(r'[A-Z]'));
    final hasLower = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'\d'));
    final hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUpper) {
      return l10n.errorPasswordUppercase;
    }

    if (!hasLower) {
      return l10n.errorPasswordLowercase;
    }

    if (!hasDigit) {
      return l10n.errorPasswordDigit;
    }

    if (!hasSpecial) {
      return l10n.errorPasswordSpecial;
    }

    return null;
  }

  static String? repeatPassword(String? password, String? repeat, AppLocalizations l10n) {
    if (repeat == null || repeat.isEmpty) {
      return l10n.errorRepeatPasswordRequired;
    }

    if (password != repeat) {
      return l10n.errorPasswordsDoNotMatch;
    }
    
    return null;
  }
}
