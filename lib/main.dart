import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/utils/result.dart';
import 'package:auth/core/validator/validator.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repo.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:auth/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:auth/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final authRepository = MockAuthRepository();
  final signInUseCase = SignInUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Validator>.value(value: const Validator()),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<SignInUseCase>.value(value: signInUseCase),
        RepositoryProvider<RegisterUseCase>.value(value: registerUseCase),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignInBloc(
              context.read<SignInUseCase>(),
              context.read<Validator>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                RegistrationBloc(context.read<RegisterUseCase>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('ru', '')],
          home: const SignInPage(),
        ),
      ),
    ),
  );
}

class MockAuthRepository implements AuthRepository {
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

  @override
  Future<Result<User, AuthFailure>> register({
    required String username,
    required String email,
    required String pass,
    required String gender,
    required String age,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'network@test.com') {
      return FailureResult(const NetworkFailure());
    }
    if (email == 'taken@test.com') {
      return FailureResult(const EmailAlreadyInUseFailure());
    }
    return Success(User(email: email, password: pass));
  }
}
