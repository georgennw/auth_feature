import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repo.dart';

class SignInUseCase {
  final AuthRepo _authRepository;

  SignInUseCase(this._authRepository);

  Future<Result<User, AuthFailure>> execute({
    required String email,
    required String pass,
  }) async {
    return _authRepository.signIn(email: email, pass: pass);
  }
}
