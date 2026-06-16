import 'dart:ui';

import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/repo/auth_repository.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
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

  runApp(
    MultiRepositoryProvider(
      providers: <SingleChildWidget>[
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<SignInUseCase>.value(value: signInUseCase),
        RepositoryProvider<RegisterUseCase>.value(value: registerUseCase),
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
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: <Locale>[Locale('en', ''), Locale('ru', '')],
          home: SignInPage(),
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
