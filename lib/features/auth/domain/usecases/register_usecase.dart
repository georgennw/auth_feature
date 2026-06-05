import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repo.dart';

class RegisterUsecase {
  final AuthRepo _repo;

  RegisterUsecase(this._repo);

  Future<Result<User, AuthFailure>> call({
    required String username,
    required String email,
    required String pass,
    required String gender,
    required String age,
  }) async {
    return await _repo.register(
      username: username,
      email: email,
      pass: pass,
      gender: gender,
      age: age,
    );
  }
}