import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';

abstract class AuthRepo {
  Future<Result<User, AuthFailure>> signIn({
    required String email,
    required String pass,
  });
  // Future<Result<User, AuthRepo>> signUp({
  //   required String email,
  //   required String pass,
  // });
  // Future<Result<User, AuthRepo>> forgotPassword({required String email});
}
