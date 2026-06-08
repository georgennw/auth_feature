import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';

abstract interface class AuthRepo {
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
}
