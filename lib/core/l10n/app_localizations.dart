import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @textSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'It’s great to see you\ntoday!'**
  String get textSignInTitle;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get hintEmail;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get hintPassword;

  /// No description provided for @linkForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get linkForgotPassword;

  /// No description provided for @buttonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get buttonSignIn;

  /// No description provided for @textDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get textDontHaveAccount;

  /// No description provided for @linkRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get linkRegister;

  /// No description provided for @providePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Provide your personal info'**
  String get providePersonalInfo;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @hintUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get hintUsername;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Password should contain a minimum of 8 and a maximum of 64 characters, including 1 uppercase Latin letter, 1 lowercase Latin letter, and 1 number'**
  String get passwordTooltip;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @hintGender.
  ///
  /// In en, this message translates to:
  /// **'Choose your gender'**
  String get hintGender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @hintAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get hintAge;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @textAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get textAlreadyHaveAccount;

  /// No description provided for @linkSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get linkSignIn;

  /// No description provided for @errUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get errUsernameRequired;

  /// No description provided for @errGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender is required'**
  String get errGenderRequired;

  /// No description provided for @errAgeRequired.
  ///
  /// In en, this message translates to:
  /// **'Age is required'**
  String get errAgeRequired;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get errorEmailRequired;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8-24 characters'**
  String get errorPasswordLength;

  /// No description provided for @errorPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password needs an uppercase letter'**
  String get errorPasswordUppercase;

  /// No description provided for @errorPasswordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password needs a lowercase letter'**
  String get errorPasswordLowercase;

  /// No description provided for @errorPasswordDigit.
  ///
  /// In en, this message translates to:
  /// **'Password needs a digit'**
  String get errorPasswordDigit;

  /// No description provided for @errorPasswordSpecial.
  ///
  /// In en, this message translates to:
  /// **'Password needs a special character'**
  String get errorPasswordSpecial;

  /// No description provided for @errorRepeatPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Repeat password is required'**
  String get errorRepeatPasswordRequired;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @serverErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again'**
  String get serverErrorInvalidCredentials;

  /// No description provided for @serverErrorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get serverErrorEmailAlreadyInUse;

  /// No description provided for @serverErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User with this email was not found'**
  String get serverErrorUserNotFound;

  /// No description provided for @serverErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection'**
  String get serverErrorNetwork;

  /// No description provided for @serverErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later'**
  String get serverErrorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
