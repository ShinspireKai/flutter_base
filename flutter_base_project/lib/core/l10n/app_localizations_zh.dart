// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
}
