import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/validator/validator_rules.dart';
import 'package:flutter/material.dart';

extension UIValidationExt on String? {
  String? toEmailError(BuildContext context) => _getError(
    context,
    EmailRule.values,
    (EmailRule rule) => rule.check(this),
    (EmailRule rule, AppLocalizations l10n) => rule.getErrorMessage(l10n),
  );
  String? toPasswordError(BuildContext context) => _getError(
    context,
    PasswordRule.values,
    (PasswordRule rule) => rule.check(this),
    (PasswordRule rule, AppLocalizations l10n) => rule.getErrorMessage(l10n),
  );
  String? toUsernameError(BuildContext context) => _getError(
    context,
    UsernameRule.values,
    (UsernameRule rule) => rule.check(this),
    (UsernameRule rule, AppLocalizations l10n) => rule.getErrorMessage(l10n),
  );
  String? toAgeError(BuildContext context) => _getError(
    context,
    AgeRule.values,
    (AgeRule rule) => rule.check(this),
    (AgeRule rule, AppLocalizations l10n) => rule.getErrorMessage(l10n),
  );
  String? toGenderError(BuildContext context) => _getError(
    context,
    GenderRule.values,
    (GenderRule rule) => rule.check(this),
    (GenderRule rule, AppLocalizations l10n) => rule.getErrorMessage(l10n),
  );

  String? _getError<T extends Enum>(
    BuildContext context,
    List<T> rules,
    bool Function(T) check,
    String Function(T, AppLocalizations) getMessage,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    for (final T rule in rules) {
      if (!check(rule)) {
        return getMessage(rule, l10n);
      }
    }
    return null;
  }
}
