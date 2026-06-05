// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get textSignInTitle => 'Рады видеть вас\nснова!';

  @override
  String get labelEmail => 'Email';

  @override
  String get hintEmail => 'Введите ваш email';

  @override
  String get labelPassword => 'Пароль';

  @override
  String get hintPassword => 'Введите ваш пароль';

  @override
  String get linkForgotPassword => 'Забыли пароль?';

  @override
  String get buttonSignIn => 'Войти';

  @override
  String get textDontHaveAccount => 'Еще нет аккаунта? ';

  @override
  String get linkRegister => 'Зарегистрироваться';

  @override
  String get providePersonalInfo => 'Укажите ваши личные данные';

  @override
  String get username => 'Имя пользователя';

  @override
  String get hintUsername => 'Введите имя пользователя';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get passwordTooltip =>
      'Пароль должен содержать от 8 до 64 символов, включая 1 заглавную латинскую букву, 1 строчную латинскую букву и 1 цифру';

  @override
  String get gender => 'Пол';

  @override
  String get hintGender => 'Выберите ваш пол';

  @override
  String get genderMale => 'Мужской';

  @override
  String get genderFemale => 'Женский';

  @override
  String get genderOther => 'Другой';

  @override
  String get age => 'Возраст';

  @override
  String get hintAge => 'Введите ваш возраст';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get textAlreadyHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get linkSignIn => 'Войти';

  @override
  String get errUsernameRequired => 'Имя пользователя обязательно';

  @override
  String get errGenderRequired => 'Выберите пол';

  @override
  String get errAgeRequired => 'Укажите возраст';

  @override
  String get errorEmailRequired => 'Email обязателен для заполнения';

  @override
  String get errorEmailInvalid => 'Неверный формат Email';

  @override
  String get errorPasswordRequired => 'Пароль обязателен для заполнения';

  @override
  String get errorPasswordLength => 'Пароль должен быть от 8 до 24 символов';

  @override
  String get errorPasswordUppercase =>
      'Пароль должен содержать заглавную букву';

  @override
  String get errorPasswordLowercase => 'Пароль должен содержать строчную букву';

  @override
  String get errorPasswordDigit => 'Пароль должен содержать цифру';

  @override
  String get errorPasswordSpecial =>
      'Пароль должен содержать специальный символ';

  @override
  String get errorRepeatPasswordRequired => 'Повторите пароль';

  @override
  String get errorPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get serverErrorInvalidCredentials =>
      'Неверный email или пароль. Попробуйте снова';

  @override
  String get serverErrorEmailAlreadyInUse =>
      'Этот Email уже зарегистрирован в системе';

  @override
  String get serverErrorUserNotFound => 'Пользователь с таким Email не найден';

  @override
  String get serverErrorNetwork =>
      'Ошибка сети. Проверьте подключение к интернету';

  @override
  String get serverErrorUnknown =>
      'Что-то пошло не так. Повторите попытку позже';
}
