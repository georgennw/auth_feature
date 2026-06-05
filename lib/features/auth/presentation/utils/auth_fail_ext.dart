import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:flutter/material.dart';

extension AuthFailureL10n on AuthFailure {
  String toLocalizeString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return switch (this) {
      InvalidCredentialsFailure() => l10n.serverErrorInvalidCredentials,
      EmailAlreadyInUseFailure() => l10n.serverErrorEmailAlreadyInUse,
      UserNotFoundFailure() => l10n.serverErrorUserNotFound,
      NetworkFailure() => l10n.serverErrorNetwork,
    };
  }
}
                                  