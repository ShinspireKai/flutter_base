// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get title_login_appbar => '新達 EIP · 巡檢';

  @override
  String get app_name => '英文名言';

  @override
  String get no_route_found => '未找到路线';

  @override
  String get success => '成功';

  @override
  String get cancel => '取消';

  @override
  String get bad_request_error => '错误的请求，请稍后再试。';

  @override
  String get no_content => '成功但没有内容';

  @override
  String get forbidden_error => '请求被禁止，请稍后再试。';

  @override
  String get unauthorized_error => '未授权的用户，请稍后再试。';

  @override
  String get not_found_error => '未找到URL，请稍后再试。';

  @override
  String get conflict_error => '发现冲突，请稍后再试。';

  @override
  String get internal_server_error => '发生错误，请稍后再试。';

  @override
  String get unknown_error => '发生错误，请稍后再试。';

  @override
  String get timeout_error => '超时，请稍后再试。';

  @override
  String get default_error => '发生错误，请稍后再试。';

  @override
  String get cache_error => '缓存错误，请稍后再试。';

  @override
  String get no_internet_error => '请检查您的互联网连接。';

  @override
  String get tilteQuoteoftheday => '今日名言';

  @override
  String get decriptionQuoteoftheday =>
      '这是一个禁忌话题。死者如何被生者背叛。我们这些活着的人——那些幸存下来的人——明白，我们的愧疚感是我们与死者联系在一起的纽带。我们随时都能听到他们在呼唤我们，他们的声音中充满了越来越多的难以置信，你不会忘记我——是吗？你怎么能忘记我？除了你，我没有别人。';

  @override
  String get authors => '作者: ';

  @override
  String get tags => '标签: ';

  @override
  String get tilteAuthorHasBirthdayToday => '今天过生日的作者';

  @override
  String get tilteTopAuthor => '前五名作者';

  @override
  String get tilteTopTags => '前十个标签';

  @override
  String get sourceText =>
      '来源：Walter Cronkite.（n.d.）。 AZQuotes.com. 于2024年7月8日从AZQuotes.com网站检索：https://www.azquotes.com/quote/1060774';

  @override
  String get topicOfQuote => '名言主题：';

  @override
  String get relatedAuthor => '相关作者';

  @override
  String get previousTextButton => '<< 上一页';

  @override
  String get nextTextButton => '下一页 >>';

  @override
  String get authorInformation => '作者信息';

  @override
  String get nameAuthor => '名字: ';

  @override
  String get brithday => '出生日期: ';

  @override
  String get occupation => '职业: ';

  @override
  String get save => '儲存';

  @override
  String get retryButton => '重試';

  @override
  String get errorOccurredTitle => '發生錯誤';

  @override
  String get logoutAction => '登出';

  @override
  String get logoutConfirmMessage => '您確定要登出嗎？\n您將需要重新登入才能使用此應用程式。';

  @override
  String get loggingOut => '登出中...';

  @override
  String get comingSoon => '功能即將推出';

  @override
  String get appTagline => '巡檢電子化';

  @override
  String get companyCodeLabel => '公司代碼';

  @override
  String get companyCodeRequired => '請輸入公司代碼';

  @override
  String get accountLabel => '帳號';

  @override
  String get accountHint => '員工帳號';

  @override
  String get accountRequired => '請輸入帳號';

  @override
  String get passwordLabel => '密碼';

  @override
  String get passwordRequired => '請輸入密碼';

  @override
  String get rememberMe => '記住我';

  @override
  String get loginButton => '登入';

  @override
  String get biometricLoginButton => '🔒 生物辨識登入';

  @override
  String get biometricAuthReason => '驗證以登入應用程式';

  @override
  String get biometricAuthFailed => '生物辨識驗證失敗或已取消。';

  @override
  String get demoInfoLabel => '示範資訊';

  @override
  String get demoInspectorLabel => '巡檢人員: ';

  @override
  String get demoContractorLabel => '外包廠商: ';

  @override
  String get contractorHomeTitle => '維修人員 / 外包廠商 — 首頁';

  @override
  String get greetingMorning => '早安 ☀️';

  @override
  String get greetingAfternoon => '午安 🌤';

  @override
  String get greetingEvening => '晚安 🌙';

  @override
  String get sectionStatistics => '統計';

  @override
  String get sectionFeatures => '功能';

  @override
  String get statProjects => '專案';

  @override
  String get statTasks => '任務';

  @override
  String get statNotifications => '通知';

  @override
  String get menuProfile => '個人資料';

  @override
  String get menuSettings => '設定';

  @override
  String get menuSupport => '支援';

  @override
  String joinedSince(String date) {
    return '加入於 $date';
  }

  @override
  String get selectFeatureHint => '請選擇功能（依權限顯示）';

  @override
  String get todayInspectionLabel => '今日巡檢';

  @override
  String get roleInspector => '巡檢人員';

  @override
  String get myRepairTasksLabel => '我的維修任務';

  @override
  String get roleTechnician => '維修人員';

  @override
  String get pendingRecheckLabel => '待複檢';

  @override
  String maintenanceAssignedToMe(String name) {
    return '派給我的異常維修・$name';
  }

  @override
  String get maintenanceStatusInProgress => '維修中';

  @override
  String get maintenanceStatusPending => '待維修';

  @override
  String get noMaintenanceTasks => '目前沒有維修任務';

  @override
  String assignedDateSuffix(String date) {
    return '$date 派工';
  }

  @override
  String get maintenanceReportTitle => '維修回報';

  @override
  String get maintenanceReworkTitle => '再維修';

  @override
  String get maintenanceStatusReworking => '維修中（再維修）';

  @override
  String get maintenanceStatusPendingRecheck => '待複檢';

  @override
  String get maintenanceStatusCompleted => '已完成';

  @override
  String reportedByInline(String name, String datetime) {
    return '通報：$name．$datetime';
  }

  @override
  String assignedByInline(String name, String datetime) {
    return '委派：$name．$datetime';
  }

  @override
  String reportPhotosLabel(int count) {
    return '通報照片 ×$count';
  }

  @override
  String get rejectionReasonSectionTitle => '複檢退回原因';

  @override
  String rejectionReasonSuffix(String reviewer, String datetime) {
    return '（$reviewer · $datetime）';
  }

  @override
  String get completionNoteLabel => '完工說明';

  @override
  String get completionNoteLabelRework => '本次完工說明';

  @override
  String get completionNoteHintRework => '（請輸入再次處理結果）';

  @override
  String get completionNoteRequiredWarning => '請先輸入完工說明，再送出。';

  @override
  String get completionPhotosLabel => '完工照片';

  @override
  String get updateProgressButton => '更新進度';

  @override
  String get completeSendRecheckButton => '完成，送複檢';

  @override
  String get completeSendRecheckAgainButton => '完成，再送複檢';

  @override
  String get progressSavedToast => '已更新進度';

  @override
  String get sentForRecheckToast => '已送出，等待複檢';

  @override
  String get taskAlreadyCompletedNotice => '此任務已完成';

  @override
  String get pendingRecheckListTitle => '待我複檢';

  @override
  String pendingRecheckSubtitle(String reviewer) {
    return '維修完成、待複檢項目．$reviewer';
  }

  @override
  String completedAtSuffix(String date) {
    return '維修完成 $date';
  }

  @override
  String get noPendingRecheckTasks => '目前沒有待複檢的項目';

  @override
  String get recheckDecisionTitle => '異常複檢';

  @override
  String get reportDescriptionLabel => '通報說明';

  @override
  String get repairedByLabel => '維修人員';

  @override
  String get recheckViewPhotosLink => '查看';

  @override
  String get recheckResultSectionTitle => '複檢結果';

  @override
  String get recheckApproveButton => '通過';

  @override
  String get recheckRejectButton => '不通過';

  @override
  String get recheckNoteLabel => '複檢說明';

  @override
  String get recheckNoteHint => '請輸入複檢意見';

  @override
  String get recheckNoteRequiredWarning => '請先輸入複檢說明，再送出。';

  @override
  String get submitRecheckButton => '送出複檢';

  @override
  String get recheckRuleApprovedNote => '✓ 通過 → 已完成（結案）';

  @override
  String get recheckRuleRejectedNote => '✗ 不通過 → 退回待派工，重新派工維修';

  @override
  String get recheckApprovedToast => '複檢已通過，案件已結案';

  @override
  String get recheckRejectedToast => '複檢未通過，已退回重新維修';

  @override
  String inspectorLabelWithName(String name) {
    return '巡檢員：$name';
  }

  @override
  String get noInspectionItemsToday => '今天沒有巡檢項目';

  @override
  String get noteDialogTitle => '備註';

  @override
  String get noteHint => '請輸入異常說明...';

  @override
  String get takePhoto => '拍照';

  @override
  String get chooseFromGallery => '從相簿選擇';

  @override
  String incompleteChecklistWarning(int count) {
    return '還有 $count 項尚未完成，請完成所有項目後再送出。';
  }

  @override
  String routeLocationInline(String location, String name) {
    return '$location・路線：$name';
  }

  @override
  String get submitInspectionReport => '送出巡檢報告';

  @override
  String get inspectionCompletedTitle => '巡檢完成';

  @override
  String get reportSubmittedMessage => '巡檢報告已送出';

  @override
  String get routeLabel => '路線';

  @override
  String get completedLabel => '完成';

  @override
  String get abnormalLabel => '異常';

  @override
  String abnormalCountReported(int count) {
    return '$count 項（已通報）';
  }

  @override
  String abnormalCountUnit(int count) {
    return '$count 項';
  }

  @override
  String get submittedAtLabel => '送出時間';

  @override
  String get backToTodayInspection => '回今日巡檢';

  @override
  String photoRecordTitle(int index, String name) {
    return '拍照記錄 · $index. $name';
  }

  @override
  String get photoRecordButtonLabel => '拍照記錄';

  @override
  String get multiplePhotosHint => '異常項目可附多張照片';

  @override
  String get severityLevelLabel => '異常等級';

  @override
  String get severityHighHint => '🔴 高：需立即處理（系統優先分派工單）。';

  @override
  String get severityMediumHint => '🟡 中：需於規定時限內處理。';

  @override
  String get severityLowHint => '⚪ 低：持續觀察或依保養排程處理。';

  @override
  String get abnormalDescriptionLabel => '異常說明';

  @override
  String get openCamera => '開啟相機';

  @override
  String get doneBackToChecklist => '完成，回檢查表';

  @override
  String get signatureRequiredWarning => '請先簽名確認，再送出報告。';

  @override
  String get signatureConfirmationTitle => '簽名確認';

  @override
  String get inspectorSignatureLabel => '巡檢員簽名';

  @override
  String get completedItemsLabel => '完成項目';

  @override
  String get abnormalItemsLabel => '異常項目';

  @override
  String get signHerePlaceholder => '✍ 請於此處簽名';

  @override
  String get clearAndResign => '清除重簽';

  @override
  String get confirmSubmit => '確認送出';

  @override
  String get drawerHome => '首頁';

  @override
  String get statusNormal => '正常';

  @override
  String get abnormalWithLevelPrefix => '異常・等級 ';

  @override
  String get checklistNotFilledYet => '尚未填寫等級／照片／備註';

  @override
  String photoCountLabel(int count) {
    return '照片 ×$count';
  }

  @override
  String completedCountLabel(int completed, int total) {
    return '$completed/$total 已完成';
  }

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusInProgress => '進行中';

  @override
  String get statusNotStarted => '未開始';

  @override
  String get contractorEntryTitle => '維修單回報';

  @override
  String get contractorEntryInstructionLine1 => '由簡訊／Email 連結開啟，網址內含單號';

  @override
  String contractorEntryInstructionExample(String ticketNo) {
    return '例：eip.shinspire.com.tw/repair?no=$ticketNo';
  }

  @override
  String get contractorEntryTicketNoLabel => '報修單';

  @override
  String get contractorEntryIssueLabel => '異常';

  @override
  String get contractorEntryAssignedContractorLabel => '委派廠商';

  @override
  String get contractorEntryCodeHint => '請輸入 6 位數代碼';

  @override
  String get contractorEntryConfirmButton => '確認進入';

  @override
  String get contractorEntryFootnote => '※ 代碼隨派工以簡訊發送，限本單號使用、具期限';

  @override
  String get contractorEntryMissingTicket => '請由簡訊／Email 連結開啟本頁面';

  @override
  String get contractorEntryInvalidCode => '代碼錯誤，請重新輸入';

  @override
  String get contractorEntryTicketNotFound => '查無此報修單';

  @override
  String contractorReportTitle(String ticketNo) {
    return '維修回報．#$ticketNo';
  }

  @override
  String get contractorEntryCodeLabel => '進入代碼';

  @override
  String get severityLowLabel => '⚪ 低';

  @override
  String get severityMediumLabel => '🟡 中';

  @override
  String get severityHighLabel => '🔴 高';

  @override
  String get currentStatusLabel => '目前狀態：';

  @override
  String get weekdayMon => '一';

  @override
  String get weekdayTue => '二';

  @override
  String get weekdayWed => '三';

  @override
  String get weekdayThu => '四';

  @override
  String get weekdayFri => '五';

  @override
  String get weekdaySat => '六';

  @override
  String get weekdaySun => '日';

  @override
  String get notificationChannelName => '一般通知';

  @override
  String get notificationChannelDescription => '應用程式預設通知頻道';

  @override
  String get genericErrorTitle => '錯誤';

  @override
  String get genericNoticeTitle => '通知';

  @override
  String get closeButton => '關閉';

  @override
  String fcmTokenSnackbarMessage(String token) {
    return 'FCM Token：$token';
  }

  @override
  String get copyButtonLabel => '複製';

  @override
  String get fcmTokenCopiedToast => '已複製 FCM Token';

  @override
  String get splashAppName => 'Flutter Base';

  @override
  String get splashTagline => 'Clean Architecture · BLoC · MVP';
}
