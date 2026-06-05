// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get textSignInTitle => 'It’s great to see you\ntoday!';

  @override
  String get labelEmail => 'Email';

  @override
  String get hintEmail => 'Enter your email';

  @override
  String get labelPassword => 'Password';

  @override
  String get hintPassword => 'Enter your password';

  @override
  String get linkForgotPassword => 'Forgot password?';

  @override
  String get buttonSignIn => 'Sign in';

  @override
  String get textDontHaveAccount => 'Don’t have an account? ';

  @override
  String get linkRegister => 'Register';

  @override
  String get providePersonalInfo => 'Provide your personal info';

  @override
  String get username => 'Username';

  @override
  String get hintUsername => 'Enter your username';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get passwordTooltip =>
      'Password should contain a minimum of 8 and a maximum of 64 characters, including 1 uppercase Latin letter, 1 lowercase Latin letter, and 1 number';

  @override
  String get gender => 'Gender';

  @override
  String get hintGender => 'Choose your gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get age => 'Age';

  @override
  String get hintAge => 'Enter your age';

  @override
  String get register => 'Register';

  @override
  String get textAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get linkSignIn => 'Sign In';

  @override
  String get errUsernameRequired => 'Username is required';

  @override
  String get errGenderRequired => 'Gender is required';

  @override
  String get errAgeRequired => 'Age is required';

  @override
  String get errorEmailRequired => 'Email is required';

  @override
  String get errorEmailInvalid => 'Invalid email format';

  @override
  String get errorPasswordRequired => 'Password is required';

  @override
  String get errorPasswordLength => 'Password must be 8-24 characters';

  @override
  String get errorPasswordUppercase => 'Password needs an uppercase letter';

  @override
  String get errorPasswordLowercase => 'Password needs a lowercase letter';

  @override
  String get errorPasswordDigit => 'Password needs a digit';

  @override
  String get errorPasswordSpecial => 'Password needs a special character';

  @override
  String get errorRepeatPasswordRequired => 'Repeat password is required';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get serverErrorInvalidCredentials =>
      'Invalid email or password. Please try again';

  @override
  String get serverErrorEmailAlreadyInUse => 'This email is already registered';

  @override
  String get serverErrorUserNotFound => 'User with this email was not found';

  @override
  String get serverErrorNetwork =>
      'Network error. Please check your internet connection';

  @override
  String get serverErrorUnknown =>
      'Something went wrong. Please try again later';
}
