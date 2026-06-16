import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Result<void, AuthFailure>> sendOtp(String email) =>
      _repository.sendRecoveryOtp(email);

  Future<Result<void, AuthFailure>> verifyOtp(String email, String code) =>
      _repository.verifyRecoveryOtp(email, code);

  Future<Result<void, AuthFailure>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _repository.resetPassword(
    email: email,
    code: code,
    newPassword: newPassword,
  );
}
