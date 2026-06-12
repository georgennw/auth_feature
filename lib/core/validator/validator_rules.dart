import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/utils/constants.dart';

enum EmailRule {
  required,
  invalid;

  bool check(String? value) {
    if (this == EmailRule.required) return value != null && value.isNotEmpty;
    if (value == null || value.isEmpty) return false;

    return switch (this) {
      EmailRule.required => true,
      EmailRule.invalid => ValidationRegex.email.hasMatch(value.trim()),
    };
  }

  String getErrorMessage(AppLocalizations l10n) {
    return switch (this) {
      EmailRule.required => l10n.errorEmailRequired,
      EmailRule.invalid => l10n.errorEmailInvalid,
    };
  }
}

enum PasswordRule {
  required,
  length,
  uppercase,
  lowercase,
  digit,
  specialChar;

  bool check(String? value) {
    if (this == PasswordRule.required) return value != null && value.isNotEmpty;
    if (value == null || value.isEmpty) return false;

    return switch (this) {
      PasswordRule.required => true,
      PasswordRule.length =>
        value.length >= ValidationConstants.minPasswordLength &&
            value.length <= ValidationConstants.maxPasswordLength,
      PasswordRule.uppercase => value.contains(ValidationRegex.uppercase),
      PasswordRule.lowercase => value.contains(ValidationRegex.lowercase),
      PasswordRule.digit => value.contains(ValidationRegex.digit),
      PasswordRule.specialChar => value.contains(ValidationRegex.specialChar),
    };
  }

  String getErrorMessage(AppLocalizations l10n) {
    return switch (this) {
      PasswordRule.required => l10n.errorPasswordRequired,
      PasswordRule.length => l10n.errorPasswordLength,
      PasswordRule.uppercase => l10n.errorPasswordUppercase,
      PasswordRule.lowercase => l10n.errorPasswordLowercase,
      PasswordRule.digit => l10n.errorPasswordDigit,
      PasswordRule.specialChar => l10n.errorPasswordSpecial,
    };
  }
}

enum UsernameRule {
  required,
  tooLong;

  bool check(String? value) {
    if (this == UsernameRule.required) {
      return value != null && value.trim().isNotEmpty;
    }
    if (value == null || value.trim().isEmpty) return false;

    return switch (this) {
      UsernameRule.required => true,
      UsernameRule.tooLong =>
        value.trim().length < ValidationConstants.maxUsernameLength,
    };
  }

  String getErrorMessage(AppLocalizations l10n) {
    return switch (this) {
      UsernameRule.required => l10n.errorUsernameRequired,
      UsernameRule.tooLong => l10n.errorUsernameRequired,
    };
  }
}

enum AgeRule {
  required,
  invalid;

  bool check(String? value) {
    if (this == AgeRule.required) {
      return value != null && value.trim().isNotEmpty;
    }
    if (value == null || value.trim().isEmpty) return false;

    final int? age = int.tryParse(value.trim());
    return switch (this) {
      AgeRule.required => true,
      AgeRule.invalid => age != null && age >= ValidationConstants.minAge,
    };
  }

  String getErrorMessage(AppLocalizations l10n) {
    return switch (this) {
      AgeRule.required => l10n.errorAgeRequired,
      AgeRule.invalid => l10n.errorAgeValidation,
    };
  }
}

enum GenderRule {
  required;

  bool check(String? value) {
    return value != null && value.isNotEmpty;
  }

  String getErrorMessage(AppLocalizations l10n) {
    return switch (this) {
      GenderRule.required => l10n.errorGenderRequired,
    };
  }
}

extension BlocValidationExt on String? {
  bool get isValidEmail =>
      EmailRule.values.every((EmailRule rule) => rule.check(this));
  bool get isValidPassword =>
      PasswordRule.values.every((PasswordRule rule) => rule.check(this));
  bool get isValidUsername =>
      UsernameRule.values.every((UsernameRule rule) => rule.check(this));
  bool get isValidGender =>
      GenderRule.values.every((GenderRule rule) => rule.check(this));
  bool get isValidAge =>
      AgeRule.values.every((AgeRule rule) => rule.check(this));
}
