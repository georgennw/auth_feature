import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/validator/validator_rules.dart';
import 'package:flutter/material.dart';

extension UIValidationExt on String? {
  String? toEmailError(BuildContext context) =>
      _getError(context, EmailRule.values);
  String? toPasswordError(BuildContext context) =>
      _getError(context, PasswordRule.values);
  String? toUsernameError(BuildContext context) =>
      _getError(context, UsernameRule.values);
  String? toAgeError(BuildContext context) =>
      _getError(context, AgeRule.values);
  String? toGenderError(BuildContext context) =>
      _getError(context, GenderRule.values);

  String? _getError(BuildContext context, List<dynamic> rules) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    
    for (final dynamic rule in rules) {
      if (!rule.check(this)) {
        return rule.getErrorMessage(l10n);
      }
    }
    return null;
  }
}
