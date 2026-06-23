import 'dart:ui';

import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/theme/app_colors.dart';
import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repository.dart';
import 'package:auth/features/auth/domain/usecases/forgot_usecase.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:auth/features/auth/presentation/pages/sign_in_page.dart';
import 'package:auth/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested/nested.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final MockAuthRepository authRepository = MockAuthRepository();
  final SignInUseCase signInUseCase = SignInUseCase(authRepository);
  final RegisterUseCase registerUseCase = RegisterUseCase(authRepository);
  final ForgotPasswordUseCase forgotPasswordUseCase = ForgotPasswordUseCase(
    authRepository,
  );

  runApp(
    MultiRepositoryProvider(
      providers: <SingleChildWidget>[
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<SignInUseCase>.value(value: signInUseCase),
        RepositoryProvider<RegisterUseCase>.value(value: registerUseCase),
        RepositoryProvider<ForgotPasswordUseCase>.value(
          value: forgotPasswordUseCase,
        ),
      ],
      child: MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider(
            create: (BuildContext context) =>
                SignInBloc(context.read<SignInUseCase>()),
          ),
          BlocProvider(
            create: (BuildContext context) =>
                RegistrationBloc(context.read<RegisterUseCase>()),
          ),
          BlocProvider(
            create: (BuildContext context) =>
                ForgotPasswordBloc(context.read<ForgotPasswordUseCase>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[Locale('en', ''), Locale('ru', '')],
          theme: ThemeData(colorSchemeSeed: AppColors.buttonInactive),
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

  @override
  Future<Result<void, AuthFailure>> verifyRecoveryOtp(
    String email,
    String code,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'network@test.com') {
      return FailureResult(const NetworkFailure());
    }
    if (code == '0000') {
      return FailureResult(const InvalidOtpFailure());
    }
    return Success(null);
  }

  @override
  Future<Result<void, AuthFailure>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'network@test.com') {
      return FailureResult(const NetworkFailure());
    }
    return Success(null);
  }
  
  @override
  Future<Result<void, AuthFailure>> sendRecoveryOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'network@test.com') {
      return FailureResult(const NetworkFailure());
    }
    return Success(null);
  }
}
