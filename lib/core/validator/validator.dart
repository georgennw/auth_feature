import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/utils/constants.dart';

class Validator {
  const Validator();

  String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.errorEmailRequired;
    }

    if (!ValidationRegex.email.hasMatch(value)) {
      return l10n.errorEmailInvalid;
    }

    return null;
  }

  String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.errorPasswordRequired;
    }

    if (value.length < ValidationConstants.minPasswordLength ||
        value.length > ValidationConstants.maxPasswordLength) {
      return l10n.errorPasswordLength;
    }

    if (!value.contains(ValidationRegex.uppercase)) {
      return l10n.errorPasswordUppercase;
    }

    if (!value.contains(ValidationRegex.lowercase)) {
      return l10n.errorPasswordLowercase;
    }

    if (!value.contains(ValidationRegex.digit)) {
      return l10n.errorPasswordDigit;
    }

    if (!value.contains(ValidationRegex.specialChar)) {
      return l10n.errorPasswordSpecial;
    }

    return null;
  }

  String? repeatPassword(
    String? password,
    String? repeat,
    AppLocalizations l10n,
  ) {
    if (repeat == null || repeat.isEmpty) {
      return l10n.errorRepeatPasswordRequired;
    }

    if (password != repeat) {
      return l10n.errorPasswordsDoNotMatch;
    }

    return null;
  }
}
