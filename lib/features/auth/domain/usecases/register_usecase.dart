import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repo.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  const RegisterUseCase(this._authRepository);

  Future<Result<User, AuthFailure>> execute({
    required String username,
    required String email,
    required String pass,
    required String gender,
    required String age,
  }) async {
    return _authRepository.register(
      username: username,
      email: email,
      pass: pass,
      gender: gender,
      age: age,
    );
  }
}
