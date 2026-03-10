// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'English Quotes';

  @override
  String get no_route_found => 'No route found';

  @override
  String get success => 'Success';

  @override
  String get cancel => 'Cancel';

  @override
  String get bad_request_error => 'Bad request. Please try again later.';

  @override
  String get no_content => 'Success with no content';

  @override
  String get forbidden_error => 'Request is forbidden. Please try again later.';

  @override
  String get unauthorized_error => 'Unauthorized user, please try again later.';

  @override
  String get not_found_error => 'URL not found, please try again later.';

  @override
  String get conflict_error => 'Conflict found, please try again later.';

  @override
  String get internal_server_error =>
      'Something went wrong, please try again later.';

  @override
  String get unknown_error => 'Something went wrong, please try again later.';

  @override
  String get timeout_error => 'Timeout, please try again later.';

  @override
  String get default_error => 'Something went wrong, please try again later.';

  @override
  String get cache_error => 'Cache error, please try again later.';

  @override
  String get no_internet_error => 'Please check your internet connection.';

  @override
  String get tilteQuoteoftheday => 'Quote of the day';

  @override
  String get decriptionQuoteoftheday =>
      'It\'s a taboo subject. How the dead are betrayed by the living. We who are living--we who have survived--understand that our guilt is what links us to the dead. At all times we can hear them calling to us, a growing incredulity in their voices, You will not forget me -- will you? How can you forget me? I have no one but you.';

  @override
  String get authors => 'Authors: ';

  @override
  String get tags => 'Tags: ';

  @override
  String get tilteAuthorHasBirthdayToday => 'Author has a birthday today';

  @override
  String get tilteTopAuthor => 'Top 5 author';

  @override
  String get tilteTopTags => 'Top 10 tags';

  @override
  String get sourceText =>
      'Source: Walter Cronkite. (n.d.). AZQuotes.com. Retrieved July 08, 2024, from AZQuotes.com Web site: https://www.azquotes.com/quote/1060774';

  @override
  String get topicOfQuote => 'Topic of quote: ';

  @override
  String get relatedAuthor => 'Related author';

  @override
  String get previousTextButton => '<< Previous';

  @override
  String get nextTextButton => 'Next >>';

  @override
  String get authorInformation => 'Author information';

  @override
  String get nameAuthor => 'Name: ';

  @override
  String get brithday => 'Date of Birth: ';

  @override
  String get occupation => 'Occupation: ';
}
