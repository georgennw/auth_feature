import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';

abstract interface class AuthRepository {
  Future<Result<User, AuthFailure>> signIn({
    required String email,
    required String pass,
  });

  Future<Result<User, AuthFailure>> register({
    required String username,
    required String email,
    required String pass,
    required String gender,
    required String age,
  });

  Future<Result<void, AuthFailure>> sendRecoveryOtp(String email);
  Future<Result<void, AuthFailure>> verifyRecoveryOtp(
    String email,
    String code,
  );
  Future<Result<void, AuthFailure>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
