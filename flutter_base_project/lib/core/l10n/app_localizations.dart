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
    Locale('zh'),
  ];

  /// No description provided for @title_login_appbar.
  ///
  /// In en, this message translates to:
  /// **'新達 EIP · Inspection'**
  String get title_login_appbar;

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

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @errorOccurredTitle.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurredTitle;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutAction;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?\nYou will need to log in again to use the app.'**
  String get logoutConfirmMessage;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Digital Inspection'**
  String get appTagline;

  /// No description provided for @companyCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Code'**
  String get companyCodeLabel;

  /// No description provided for @companyCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company code'**
  String get companyCodeRequired;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @accountHint.
  ///
  /// In en, this message translates to:
  /// **'Employee account'**
  String get accountHint;

  /// No description provided for @accountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your account'**
  String get accountRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @biometricLoginButton.
  ///
  /// In en, this message translates to:
  /// **'🔒 Biometric login'**
  String get biometricLoginButton;

  /// No description provided for @biometricAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to log in to the app'**
  String get biometricAuthReason;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed or was cancelled.'**
  String get biometricAuthFailed;

  /// No description provided for @demoInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo info'**
  String get demoInfoLabel;

  /// No description provided for @demoInspectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspector: '**
  String get demoInspectorLabel;

  /// No description provided for @demoContractorLabel.
  ///
  /// In en, this message translates to:
  /// **'Contractor: '**
  String get demoContractorLabel;

  /// No description provided for @contractorHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Technician / Contractor — Home'**
  String get contractorHomeTitle;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning ☀️'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon 🌤'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening 🌙'**
  String get greetingEvening;

  /// No description provided for @sectionStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get sectionStatistics;

  /// No description provided for @sectionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get sectionFeatures;

  /// No description provided for @statProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get statProjects;

  /// No description provided for @statTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get statTasks;

  /// No description provided for @statNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get statNotifications;

  /// No description provided for @menuProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menuProfile;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get menuSupport;

  /// No description provided for @joinedSince.
  ///
  /// In en, this message translates to:
  /// **'Joined since {date}'**
  String joinedSince(String date);

  /// No description provided for @selectFeatureHint.
  ///
  /// In en, this message translates to:
  /// **'Please select a feature (shown based on permission)'**
  String get selectFeatureHint;

  /// No description provided for @todayInspectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Inspection'**
  String get todayInspectionLabel;

  /// No description provided for @roleInspector.
  ///
  /// In en, this message translates to:
  /// **'Inspector'**
  String get roleInspector;

  /// No description provided for @myRepairTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'My Repair Tasks'**
  String get myRepairTasksLabel;

  /// No description provided for @roleTechnician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get roleTechnician;

  /// No description provided for @pendingRecheckLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending Recheck'**
  String get pendingRecheckLabel;

  /// No description provided for @maintenanceAssignedToMe.
  ///
  /// In en, this message translates to:
  /// **'Assigned to me for repair・{name}'**
  String maintenanceAssignedToMe(String name);

  /// No description provided for @maintenanceStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get maintenanceStatusInProgress;

  /// No description provided for @maintenanceStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Maintenance'**
  String get maintenanceStatusPending;

  /// No description provided for @noMaintenanceTasks.
  ///
  /// In en, this message translates to:
  /// **'No maintenance tasks'**
  String get noMaintenanceTasks;

  /// No description provided for @assignedDateSuffix.
  ///
  /// In en, this message translates to:
  /// **'Assigned {date}'**
  String assignedDateSuffix(String date);

  /// No description provided for @maintenanceReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Repair Report'**
  String get maintenanceReportTitle;

  /// No description provided for @maintenanceReworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Rework'**
  String get maintenanceReworkTitle;

  /// No description provided for @maintenanceStatusReworking.
  ///
  /// In en, this message translates to:
  /// **'In Progress (Rework)'**
  String get maintenanceStatusReworking;

  /// No description provided for @maintenanceStatusPendingRecheck.
  ///
  /// In en, this message translates to:
  /// **'Pending Recheck'**
  String get maintenanceStatusPendingRecheck;

  /// No description provided for @maintenanceStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get maintenanceStatusCompleted;

  /// No description provided for @reportedByInline.
  ///
  /// In en, this message translates to:
  /// **'Reported by: {name} · {datetime}'**
  String reportedByInline(String name, String datetime);

  /// No description provided for @assignedByInline.
  ///
  /// In en, this message translates to:
  /// **'Assigned to: {name} · {datetime}'**
  String assignedByInline(String name, String datetime);

  /// No description provided for @reportPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Report Photos ×{count}'**
  String reportPhotosLabel(int count);

  /// No description provided for @rejectionReasonSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recheck Rejection Reason'**
  String get rejectionReasonSectionTitle;

  /// No description provided for @rejectionReasonSuffix.
  ///
  /// In en, this message translates to:
  /// **'（{reviewer}．{datetime}）'**
  String rejectionReasonSuffix(String reviewer, String datetime);

  /// No description provided for @completionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion Notes'**
  String get completionNoteLabel;

  /// No description provided for @completionNoteLabelRework.
  ///
  /// In en, this message translates to:
  /// **'This Rework\'s Completion Notes'**
  String get completionNoteLabelRework;

  /// No description provided for @completionNoteHintRework.
  ///
  /// In en, this message translates to:
  /// **'(Please enter the result of this rework)'**
  String get completionNoteHintRework;

  /// No description provided for @completionNoteRequiredWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter completion notes before submitting.'**
  String get completionNoteRequiredWarning;

  /// No description provided for @completionPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion Photos'**
  String get completionPhotosLabel;

  /// No description provided for @updateProgressButton.
  ///
  /// In en, this message translates to:
  /// **'Update Progress'**
  String get updateProgressButton;

  /// No description provided for @completeSendRecheckButton.
  ///
  /// In en, this message translates to:
  /// **'Complete, Send for Recheck'**
  String get completeSendRecheckButton;

  /// No description provided for @completeSendRecheckAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Complete, Resend for Recheck'**
  String get completeSendRecheckAgainButton;

  /// No description provided for @progressSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Progress updated'**
  String get progressSavedToast;

  /// No description provided for @sentForRecheckToast.
  ///
  /// In en, this message translates to:
  /// **'Submitted — awaiting recheck'**
  String get sentForRecheckToast;

  /// No description provided for @taskAlreadyCompletedNotice.
  ///
  /// In en, this message translates to:
  /// **'This task is already completed'**
  String get taskAlreadyCompletedNotice;

  /// No description provided for @pendingRecheckListTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Recheck'**
  String get pendingRecheckListTitle;

  /// No description provided for @pendingRecheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed, awaiting recheck・{reviewer}'**
  String pendingRecheckSubtitle(String reviewer);

  /// No description provided for @completedAtSuffix.
  ///
  /// In en, this message translates to:
  /// **'Completed {date}'**
  String completedAtSuffix(String date);

  /// No description provided for @noPendingRecheckTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks pending recheck'**
  String get noPendingRecheckTasks;

  /// No description provided for @recheckDecisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recheck'**
  String get recheckDecisionTitle;

  /// No description provided for @reportDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Report Description'**
  String get reportDescriptionLabel;

  /// No description provided for @repairedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Repaired By'**
  String get repairedByLabel;

  /// No description provided for @recheckViewPhotosLink.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get recheckViewPhotosLink;

  /// No description provided for @recheckResultSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recheck Result'**
  String get recheckResultSectionTitle;

  /// No description provided for @recheckApproveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get recheckApproveButton;

  /// No description provided for @recheckRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get recheckRejectButton;

  /// No description provided for @recheckNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Recheck Notes'**
  String get recheckNoteLabel;

  /// No description provided for @recheckNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your recheck comments'**
  String get recheckNoteHint;

  /// No description provided for @recheckNoteRequiredWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter recheck notes before submitting.'**
  String get recheckNoteRequiredWarning;

  /// No description provided for @submitRecheckButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Recheck'**
  String get submitRecheckButton;

  /// No description provided for @recheckRuleApprovedNote.
  ///
  /// In en, this message translates to:
  /// **'✓ Approve → Completed (case closed)'**
  String get recheckRuleApprovedNote;

  /// No description provided for @recheckRuleRejectedNote.
  ///
  /// In en, this message translates to:
  /// **'✗ Reject → Sent back for rework and redispatch'**
  String get recheckRuleRejectedNote;

  /// No description provided for @recheckApprovedToast.
  ///
  /// In en, this message translates to:
  /// **'Recheck approved, case closed'**
  String get recheckApprovedToast;

  /// No description provided for @recheckRejectedToast.
  ///
  /// In en, this message translates to:
  /// **'Recheck rejected, sent back for rework'**
  String get recheckRejectedToast;

  /// No description provided for @inspectorLabelWithName.
  ///
  /// In en, this message translates to:
  /// **'Inspector: {name}'**
  String inspectorLabelWithName(String name);

  /// No description provided for @noInspectionItemsToday.
  ///
  /// In en, this message translates to:
  /// **'No inspection items today'**
  String get noInspectionItemsToday;

  /// No description provided for @noteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteDialogTitle;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter abnormality description...'**
  String get noteHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @incompleteChecklistWarning.
  ///
  /// In en, this message translates to:
  /// **'There are still {count} items not completed. Please complete all items before submitting.'**
  String incompleteChecklistWarning(int count);

  /// No description provided for @routeLocationInline.
  ///
  /// In en, this message translates to:
  /// **'{location} · Route: {name}'**
  String routeLocationInline(String location, String name);

  /// No description provided for @submitInspectionReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Inspection Report'**
  String get submitInspectionReport;

  /// No description provided for @inspectionCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection Completed'**
  String get inspectionCompletedTitle;

  /// No description provided for @reportSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Inspection report submitted'**
  String get reportSubmittedMessage;

  /// No description provided for @routeLabel.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get routeLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @abnormalLabel.
  ///
  /// In en, this message translates to:
  /// **'Abnormal'**
  String get abnormalLabel;

  /// No description provided for @abnormalCountReported.
  ///
  /// In en, this message translates to:
  /// **'{count} items (reported)'**
  String abnormalCountReported(int count);

  /// No description provided for @abnormalCountUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String abnormalCountUnit(int count);

  /// No description provided for @submittedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitted at'**
  String get submittedAtLabel;

  /// No description provided for @backToTodayInspection.
  ///
  /// In en, this message translates to:
  /// **'Back to Today\'s Inspection'**
  String get backToTodayInspection;

  /// No description provided for @photoRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Record · {index}. {name}'**
  String photoRecordTitle(int index, String name);

  /// No description provided for @photoRecordButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo Record'**
  String get photoRecordButtonLabel;

  /// No description provided for @multiplePhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Abnormal items can attach multiple photos'**
  String get multiplePhotosHint;

  /// No description provided for @severityLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity Level'**
  String get severityLevelLabel;

  /// No description provided for @severityHighHint.
  ///
  /// In en, this message translates to:
  /// **'🔴 High: Needs immediate action (system prioritizes work order dispatch).'**
  String get severityHighHint;

  /// No description provided for @severityMediumHint.
  ///
  /// In en, this message translates to:
  /// **'🟡 Medium: Must be handled within the specified time limit.'**
  String get severityMediumHint;

  /// No description provided for @severityLowHint.
  ///
  /// In en, this message translates to:
  /// **'⚪ Low: Continue monitoring or handle per maintenance schedule.'**
  String get severityLowHint;

  /// No description provided for @abnormalDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Abnormality Description'**
  String get abnormalDescriptionLabel;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get openCamera;

  /// No description provided for @doneBackToChecklist.
  ///
  /// In en, this message translates to:
  /// **'Done, back to checklist'**
  String get doneBackToChecklist;

  /// No description provided for @signatureRequiredWarning.
  ///
  /// In en, this message translates to:
  /// **'Please sign to confirm before submitting the report.'**
  String get signatureRequiredWarning;

  /// No description provided for @signatureConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Signature Confirmation'**
  String get signatureConfirmationTitle;

  /// No description provided for @inspectorSignatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspector Signature'**
  String get inspectorSignatureLabel;

  /// No description provided for @completedItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed Items'**
  String get completedItemsLabel;

  /// No description provided for @abnormalItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Abnormal Items'**
  String get abnormalItemsLabel;

  /// No description provided for @signHerePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'✍ Please sign here'**
  String get signHerePlaceholder;

  /// No description provided for @clearAndResign.
  ///
  /// In en, this message translates to:
  /// **'Clear & Re-sign'**
  String get clearAndResign;

  /// No description provided for @confirmSubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Submit'**
  String get confirmSubmit;

  /// No description provided for @drawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerHome;

  /// No description provided for @statusNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get statusNormal;

  /// No description provided for @abnormalWithLevelPrefix.
  ///
  /// In en, this message translates to:
  /// **'Abnormal · Level '**
  String get abnormalWithLevelPrefix;

  /// No description provided for @checklistNotFilledYet.
  ///
  /// In en, this message translates to:
  /// **'Level／Photo／Note not filled in yet'**
  String get checklistNotFilledYet;

  /// No description provided for @photoCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos ×{count}'**
  String photoCountLabel(int count);

  /// No description provided for @completedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} completed'**
  String completedCountLabel(int completed, int total);

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get statusNotStarted;

  /// No description provided for @contractorEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Repair Ticket Check-in'**
  String get contractorEntryTitle;

  /// No description provided for @contractorEntryInstructionLine1.
  ///
  /// In en, this message translates to:
  /// **'Opened from an SMS/Email link, the URL already contains the ticket number'**
  String get contractorEntryInstructionLine1;

  /// No description provided for @contractorEntryInstructionExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. eip.shinspire.com.tw/repair?no={ticketNo}'**
  String contractorEntryInstructionExample(String ticketNo);

  /// No description provided for @contractorEntryTicketNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket No.'**
  String get contractorEntryTicketNoLabel;

  /// No description provided for @contractorEntryIssueLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get contractorEntryIssueLabel;

  /// No description provided for @contractorEntryAssignedContractorLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned Contractor'**
  String get contractorEntryAssignedContractorLabel;

  /// No description provided for @contractorEntryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get contractorEntryCodeHint;

  /// No description provided for @contractorEntryConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Enter'**
  String get contractorEntryConfirmButton;

  /// No description provided for @contractorEntryFootnote.
  ///
  /// In en, this message translates to:
  /// **'※ The code was sent by SMS with the assignment — valid for this ticket only and time-limited'**
  String get contractorEntryFootnote;

  /// No description provided for @contractorEntryMissingTicket.
  ///
  /// In en, this message translates to:
  /// **'Please open this page from the SMS/Email link'**
  String get contractorEntryMissingTicket;

  /// No description provided for @contractorEntryInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code, please try again'**
  String get contractorEntryInvalidCode;

  /// No description provided for @contractorEntryTicketNotFound.
  ///
  /// In en, this message translates to:
  /// **'Ticket not found'**
  String get contractorEntryTicketNotFound;

  /// No description provided for @contractorReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Repair Report · #{ticketNo}'**
  String contractorReportTitle(String ticketNo);

  /// No description provided for @contractorEntryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Entry Code'**
  String get contractorEntryCodeLabel;

  /// No description provided for @severityLowLabel.
  ///
  /// In en, this message translates to:
  /// **'⚪ Low'**
  String get severityLowLabel;

  /// No description provided for @severityMediumLabel.
  ///
  /// In en, this message translates to:
  /// **'🟡 Medium'**
  String get severityMediumLabel;

  /// No description provided for @severityHighLabel.
  ///
  /// In en, this message translates to:
  /// **'🔴 High'**
  String get severityHighLabel;

  /// No description provided for @currentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Status:'**
  String get currentStatusLabel;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'General Notifications'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Default notification channel for the app'**
  String get notificationChannelDescription;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get genericErrorTitle;

  /// No description provided for @genericNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get genericNoticeTitle;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @fcmTokenSnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'FCM Token: {token}'**
  String fcmTokenSnackbarMessage(String token);

  /// No description provided for @copyButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButtonLabel;

  /// No description provided for @fcmTokenCopiedToast.
  ///
  /// In en, this message translates to:
  /// **'FCM token copied'**
  String get fcmTokenCopiedToast;

  /// No description provided for @splashAppName.
  ///
  /// In en, this message translates to:
  /// **'Flutter Base'**
  String get splashAppName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture · BLoC · MVP'**
  String get splashTagline;
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
    'that was used.',
  );
}
