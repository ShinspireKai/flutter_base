// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title_login_appbar => '新達 EIP · Inspection';

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

  @override
  String get save => 'Save';

  @override
  String get retryButton => 'Retry';

  @override
  String get errorOccurredTitle => 'An error occurred';

  @override
  String get logoutAction => 'Logout';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to log out?\nYou will need to log in again to use the app.';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get appTagline => 'Digital Inspection';

  @override
  String get companyCodeLabel => 'Company Code';

  @override
  String get companyCodeRequired => 'Please enter the company code';

  @override
  String get accountLabel => 'Account';

  @override
  String get accountHint => 'Employee account';

  @override
  String get accountRequired => 'Please enter your account';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get loginButton => 'Login';

  @override
  String get biometricLoginButton => '🔒 Biometric login';

  @override
  String get biometricAuthReason => 'Authenticate to log in to the app';

  @override
  String get biometricAuthFailed =>
      'Biometric authentication failed or was cancelled.';

  @override
  String get demoInfoLabel => 'Demo info';

  @override
  String get demoInspectorLabel => 'Inspector: ';

  @override
  String get demoContractorLabel => 'Contractor: ';

  @override
  String get contractorHomeTitle => 'Technician / Contractor — Home';

  @override
  String get greetingMorning => 'Good morning ☀️';

  @override
  String get greetingAfternoon => 'Good afternoon 🌤';

  @override
  String get greetingEvening => 'Good evening 🌙';

  @override
  String get sectionStatistics => 'Statistics';

  @override
  String get sectionFeatures => 'Features';

  @override
  String get statProjects => 'Projects';

  @override
  String get statTasks => 'Tasks';

  @override
  String get statNotifications => 'Notifications';

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuSupport => 'Support';

  @override
  String joinedSince(String date) {
    return 'Joined since $date';
  }

  @override
  String get selectFeatureHint =>
      'Please select a feature (shown based on permission)';

  @override
  String get todayInspectionLabel => 'Today\'s Inspection';

  @override
  String get roleInspector => 'Inspector';

  @override
  String get myRepairTasksLabel => 'My Repair Tasks';

  @override
  String get roleTechnician => 'Technician';

  @override
  String get pendingRecheckLabel => 'Pending Recheck';

  @override
  String maintenanceAssignedToMe(String name) {
    return 'Assigned to me for repair・$name';
  }

  @override
  String get maintenanceStatusInProgress => 'In Progress';

  @override
  String get maintenanceStatusPending => 'Pending Maintenance';

  @override
  String get noMaintenanceTasks => 'No maintenance tasks';

  @override
  String assignedDateSuffix(String date) {
    return 'Assigned $date';
  }

  @override
  String get maintenanceReportTitle => 'Repair Report';

  @override
  String get maintenanceReworkTitle => 'Rework';

  @override
  String get maintenanceStatusReworking => 'In Progress (Rework)';

  @override
  String get maintenanceStatusPendingRecheck => 'Pending Recheck';

  @override
  String get maintenanceStatusCompleted => 'Completed';

  @override
  String reportedByInline(String name, String datetime) {
    return 'Reported by: $name · $datetime';
  }

  @override
  String assignedByInline(String name, String datetime) {
    return 'Assigned to: $name · $datetime';
  }

  @override
  String reportPhotosLabel(int count) {
    return 'Report Photos ×$count';
  }

  @override
  String get rejectionReasonSectionTitle => 'Recheck Rejection Reason';

  @override
  String rejectionReasonSuffix(String reviewer, String datetime) {
    return '（$reviewer．$datetime）';
  }

  @override
  String get completionNoteLabel => 'Completion Notes';

  @override
  String get completionNoteLabelRework => 'This Rework\'s Completion Notes';

  @override
  String get completionNoteHintRework =>
      '(Please enter the result of this rework)';

  @override
  String get completionNoteRequiredWarning =>
      'Please enter completion notes before submitting.';

  @override
  String get completionPhotosLabel => 'Completion Photos';

  @override
  String get updateProgressButton => 'Update Progress';

  @override
  String get completeSendRecheckButton => 'Complete, Send for Recheck';

  @override
  String get completeSendRecheckAgainButton => 'Complete, Resend for Recheck';

  @override
  String get progressSavedToast => 'Progress updated';

  @override
  String get sentForRecheckToast => 'Submitted — awaiting recheck';

  @override
  String get taskAlreadyCompletedNotice => 'This task is already completed';

  @override
  String get pendingRecheckListTitle => 'Pending Recheck';

  @override
  String pendingRecheckSubtitle(String reviewer) {
    return 'Completed, awaiting recheck・$reviewer';
  }

  @override
  String completedAtSuffix(String date) {
    return 'Completed $date';
  }

  @override
  String get noPendingRecheckTasks => 'No tasks pending recheck';

  @override
  String get recheckDecisionTitle => 'Recheck';

  @override
  String get reportDescriptionLabel => 'Report Description';

  @override
  String get repairedByLabel => 'Repaired By';

  @override
  String get recheckViewPhotosLink => 'View';

  @override
  String get recheckResultSectionTitle => 'Recheck Result';

  @override
  String get recheckApproveButton => 'Approve';

  @override
  String get recheckRejectButton => 'Reject';

  @override
  String get recheckNoteLabel => 'Recheck Notes';

  @override
  String get recheckNoteHint => 'Enter your recheck comments';

  @override
  String get recheckNoteRequiredWarning =>
      'Please enter recheck notes before submitting.';

  @override
  String get submitRecheckButton => 'Submit Recheck';

  @override
  String get recheckRuleApprovedNote => '✓ Approve → Completed (case closed)';

  @override
  String get recheckRuleRejectedNote =>
      '✗ Reject → Sent back for rework and redispatch';

  @override
  String get recheckApprovedToast => 'Recheck approved, case closed';

  @override
  String get recheckRejectedToast => 'Recheck rejected, sent back for rework';

  @override
  String inspectorLabelWithName(String name) {
    return 'Inspector: $name';
  }

  @override
  String get noInspectionItemsToday => 'No inspection items today';

  @override
  String get noteDialogTitle => 'Note';

  @override
  String get noteHint => 'Please enter abnormality description...';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String incompleteChecklistWarning(int count) {
    return 'There are still $count items not completed. Please complete all items before submitting.';
  }

  @override
  String routeLocationInline(String location, String name) {
    return '$location · Route: $name';
  }

  @override
  String get submitInspectionReport => 'Submit Inspection Report';

  @override
  String get inspectionCompletedTitle => 'Inspection Completed';

  @override
  String get reportSubmittedMessage => 'Inspection report submitted';

  @override
  String get routeLabel => 'Route';

  @override
  String get completedLabel => 'Completed';

  @override
  String get abnormalLabel => 'Abnormal';

  @override
  String abnormalCountReported(int count) {
    return '$count items (reported)';
  }

  @override
  String abnormalCountUnit(int count) {
    return '$count items';
  }

  @override
  String get submittedAtLabel => 'Submitted at';

  @override
  String get backToTodayInspection => 'Back to Today\'s Inspection';

  @override
  String photoRecordTitle(int index, String name) {
    return 'Photo Record · $index. $name';
  }

  @override
  String get photoRecordButtonLabel => 'Photo Record';

  @override
  String get multiplePhotosHint => 'Abnormal items can attach multiple photos';

  @override
  String get severityLevelLabel => 'Severity Level';

  @override
  String get severityHighHint =>
      '🔴 High: Needs immediate action (system prioritizes work order dispatch).';

  @override
  String get severityMediumHint =>
      '🟡 Medium: Must be handled within the specified time limit.';

  @override
  String get severityLowHint =>
      '⚪ Low: Continue monitoring or handle per maintenance schedule.';

  @override
  String get abnormalDescriptionLabel => 'Abnormality Description';

  @override
  String get openCamera => 'Open Camera';

  @override
  String get doneBackToChecklist => 'Done, back to checklist';

  @override
  String get signatureRequiredWarning =>
      'Please sign to confirm before submitting the report.';

  @override
  String get signatureConfirmationTitle => 'Signature Confirmation';

  @override
  String get inspectorSignatureLabel => 'Inspector Signature';

  @override
  String get completedItemsLabel => 'Completed Items';

  @override
  String get abnormalItemsLabel => 'Abnormal Items';

  @override
  String get signHerePlaceholder => '✍ Please sign here';

  @override
  String get clearAndResign => 'Clear & Re-sign';

  @override
  String get confirmSubmit => 'Confirm Submit';

  @override
  String get drawerHome => 'Home';

  @override
  String get statusNormal => 'Normal';

  @override
  String get abnormalWithLevelPrefix => 'Abnormal · Level ';

  @override
  String get checklistNotFilledYet => 'Level／Photo／Note not filled in yet';

  @override
  String photoCountLabel(int count) {
    return 'Photos ×$count';
  }

  @override
  String completedCountLabel(int completed, int total) {
    return '$completed/$total completed';
  }

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusNotStarted => 'Not Started';

  @override
  String get contractorEntryTitle => 'Repair Ticket Check-in';

  @override
  String get contractorEntryInstructionLine1 =>
      'Opened from an SMS/Email link, the URL already contains the ticket number';

  @override
  String contractorEntryInstructionExample(String ticketNo) {
    return 'e.g. eip.shinspire.com.tw/repair?no=$ticketNo';
  }

  @override
  String get contractorEntryTicketNoLabel => 'Ticket No.';

  @override
  String get contractorEntryIssueLabel => 'Issue';

  @override
  String get contractorEntryAssignedContractorLabel => 'Assigned Contractor';

  @override
  String get contractorEntryCodeHint => 'Enter the 6-digit code';

  @override
  String get contractorEntryConfirmButton => 'Confirm & Enter';

  @override
  String get contractorEntryFootnote =>
      '※ The code was sent by SMS with the assignment — valid for this ticket only and time-limited';

  @override
  String get contractorEntryMissingTicket =>
      'Please open this page from the SMS/Email link';

  @override
  String get contractorEntryInvalidCode => 'Incorrect code, please try again';

  @override
  String get contractorEntryTicketNotFound => 'Ticket not found';

  @override
  String contractorReportTitle(String ticketNo) {
    return 'Repair Report · #$ticketNo';
  }

  @override
  String get contractorEntryCodeLabel => 'Entry Code';

  @override
  String get severityLowLabel => '⚪ Low';

  @override
  String get severityMediumLabel => '🟡 Medium';

  @override
  String get severityHighLabel => '🔴 High';

  @override
  String get currentStatusLabel => 'Current Status:';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get notificationChannelName => 'General Notifications';

  @override
  String get notificationChannelDescription =>
      'Default notification channel for the app';

  @override
  String get genericErrorTitle => 'Error';

  @override
  String get genericNoticeTitle => 'Notice';

  @override
  String get closeButton => 'Close';

  @override
  String fcmTokenSnackbarMessage(String token) {
    return 'FCM Token: $token';
  }

  @override
  String get copyButtonLabel => 'Copy';

  @override
  String get fcmTokenCopiedToast => 'FCM token copied';

  @override
  String get splashAppName => 'Flutter Base';

  @override
  String get splashTagline => 'Clean Architecture · BLoC · MVP';
}
