import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'English Quotes'**
  String get app_name;

  /// No description provided for @no_route_found.
  ///
  /// In en, this message translates to:
  /// **'No route found'**
  String get no_route_found;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @bad_request_error.
  ///
  /// In en, this message translates to:
  /// **'Bad request. Please try again later.'**
  String get bad_request_error;

  /// No description provided for @no_content.
  ///
  /// In en, this message translates to:
  /// **'Success with no content'**
  String get no_content;

  /// No description provided for @forbidden_error.
  ///
  /// In en, this message translates to:
  /// **'Request is forbidden. Please try again later.'**
  String get forbidden_error;

  /// No description provided for @unauthorized_error.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized user, please try again later.'**
  String get unauthorized_error;

  /// No description provided for @not_found_error.
  ///
  /// In en, this message translates to:
  /// **'URL not found, please try again later.'**
  String get not_found_error;

  /// No description provided for @conflict_error.
  ///
  /// In en, this message translates to:
  /// **'Conflict found, please try again later.'**
  String get conflict_error;

  /// No description provided for @internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get internal_server_error;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get unknown_error;

  /// No description provided for @timeout_error.
  ///
  /// In en, this message translates to:
  /// **'Timeout, please try again later.'**
  String get timeout_error;

  /// No description provided for @default_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get default_error;

  /// No description provided for @cache_error.
  ///
  /// In en, this message translates to:
  /// **'Cache error, please try again later.'**
  String get cache_error;

  /// No description provided for @no_internet_error.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get no_internet_error;

  /// No description provided for @tilteQuoteoftheday.
  ///
  /// In en, this message translates to:
  /// **'Quote of the day'**
  String get tilteQuoteoftheday;

  /// No description provided for @decriptionQuoteoftheday.
  ///
  /// In en, this message translates to:
  /// **'It\'s a taboo subject. How the dead are betrayed by the living. We who are living--we who have survived--understand that our guilt is what links us to the dead. At all times we can hear them calling to us, a growing incredulity in their voices, You will not forget me -- will you? How can you forget me? I have no one but you.'**
  String get decriptionQuoteoftheday;

  /// No description provided for @authors.
  ///
  /// In en, this message translates to:
  /// **'Authors: '**
  String get authors;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags: '**
  String get tags;

  /// No description provided for @tilteAuthorHasBirthdayToday.
  ///
  /// In en, this message translates to:
  /// **'Author has a birthday today'**
  String get tilteAuthorHasBirthdayToday;

  /// No description provided for @tilteTopAuthor.
  ///
  /// In en, this message translates to:
  /// **'Top 5 author'**
  String get tilteTopAuthor;

  /// No description provided for @tilteTopTags.
  ///
  /// In en, this message translates to:
  /// **'Top 10 tags'**
  String get tilteTopTags;

  /// No description provided for @sourceText.
  ///
  /// In en, this message translates to:
  /// **'Source: Walter Cronkite. (n.d.). AZQuotes.com. Retrieved July 08, 2024, from AZQuotes.com Web site: https://www.azquotes.com/quote/1060774'**
  String get sourceText;

  /// No description provided for @topicOfQuote.
  ///
  /// In en, this message translates to:
  /// **'Topic of quote: '**
  String get topicOfQuote;

  /// No description provided for @relatedAuthor.
  ///
  /// In en, this message translates to:
  /// **'Related author'**
  String get relatedAuthor;

  /// No description provided for @previousTextButton.
  ///
  /// In en, this message translates to:
  /// **'<< Previous'**
  String get previousTextButton;

  /// No description provided for @nextTextButton.
  ///
  /// In en, this message translates to:
  /// **'Next >>'**
  String get nextTextButton;

  /// No description provided for @authorInformation.
  ///
  /// In en, this message translates to:
  /// **'Author information'**
  String get authorInformation;

  /// No description provided for @nameAuthor.
  ///
  /// In en, this message translates to:
  /// **'Name: '**
  String get nameAuthor;

  /// No description provided for @brithday.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth: '**
  String get brithday;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation: '**
  String get occupation;
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
      <String>['en', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
