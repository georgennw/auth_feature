import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repo.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:auth/features/auth/presentation/%20bloc/sign_in_bloc.dart';
import 'package:auth/features/auth/presentation/pages/sign_in_page.dart';
import 'package:auth/features/auth/presentation/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = MockAuthRepository();

  final signInUseCase = SignInUsecase(authRepository);
  runApp(
    BlocProvider(
      create: (_) => SignInBloc(signInUseCase),
      child: MaterialApp(home: const SignInPage()),
    ),
  );
}

class MockAuthRepository implements AuthRepo {
  @override
  Future<Result<User, AuthFailure>> signIn({
    required String email,
    required String pass,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@test.com' && pass == '12345678Ab!') {
      return Success(User(email: '1', password: pass));
    }
    if (email == 'network@test.com') {
      return FailureResult(const NetworkFailure());
    }
    return FailureResult(const InvalidCredentialsFailure());
  }
}
