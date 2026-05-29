import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repo.dart';

class SignInUsecase {
  final AuthRepo _repo;

  SignInUsecase(this._repo);

  Future<Result<User, AuthFailure>> call({
    required String email,
    required String pass,
  }) async {
    return await _repo.signIn(email: email, pass: pass);
  }
}
