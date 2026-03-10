// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get app_name => 'Trích Dẫn Tiếng Anh';

  @override
  String get no_route_found => 'Không tìm thấy đường dẫn';

  @override
  String get success => 'Thành công';

  @override
  String get cancel => 'Hủy';

  @override
  String get bad_request_error => 'Yêu cầu không hợp lệ. Vui lòng thử lại sau.';

  @override
  String get no_content => 'Thành công nhưng không có nội dung';

  @override
  String get forbidden_error => 'Yêu cầu bị cấm. Vui lòng thử lại sau.';

  @override
  String get unauthorized_error =>
      'Người dùng không được ủy quyền, vui lòng thử lại sau.';

  @override
  String get not_found_error => 'Không tìm thấy URL, vui lòng thử lại sau.';

  @override
  String get conflict_error => 'Có xung đột, vui lòng thử lại sau.';

  @override
  String get internal_server_error => 'Có lỗi xảy ra, vui lòng thử lại sau.';

  @override
  String get unknown_error => 'Có lỗi xảy ra, vui lòng thử lại sau.';

  @override
  String get timeout_error => 'Hết thời gian, vui lòng thử lại sau.';

  @override
  String get default_error => 'Có lỗi xảy ra, vui lòng thử lại sau.';

  @override
  String get cache_error => 'Lỗi bộ nhớ đệm, vui lòng thử lại sau.';

  @override
  String get no_internet_error => 'Vui lòng kiểm tra kết nối internet của bạn.';

  @override
  String get tilteQuoteoftheday => 'Trích dẫn trong ngày';

  @override
  String get decriptionQuoteoftheday =>
      'Đó là một chủ đề cấm kỵ. Cách mà người chết bị phản bội bởi người sống. Chúng ta, những người sống - những người đã sống sót - hiểu rằng cảm giác tội lỗi của chúng ta là thứ kết nối chúng ta với người chết. Mọi lúc, chúng ta có thể nghe thấy họ gọi chúng ta, với sự kinh ngạc ngày càng tăng trong giọng nói của họ, Bạn sẽ không quên tôi - phải không? Làm sao bạn có thể quên tôi? Tôi không có ai ngoài bạn.';

  @override
  String get authors => 'Tác giả: ';

  @override
  String get tags => 'Thẻ: ';

  @override
  String get tilteAuthorHasBirthdayToday => 'Tác giả có sinh nhật hôm nay';

  @override
  String get tilteTopAuthor => 'Top 5 tác giả hàng đầu';

  @override
  String get tilteTopTags => 'Top 10 thẻ';

  @override
  String get sourceText =>
      'Nguồn: Walter Cronkite. (n.d.). AZQuotes.com. Truy cập ngày 08 tháng 7, 2024, từ trang web AZQuotes.com: https://www.azquotes.com/quote/1060774';

  @override
  String get topicOfQuote => 'Chủ đề của trích dẫn: ';

  @override
  String get relatedAuthor => 'Tác giả liên quan';

  @override
  String get previousTextButton => '<< Trước';

  @override
  String get nextTextButton => 'Tiếp theo >>';

  @override
  String get authorInformation => 'Thông tin tác giả';

  @override
  String get nameAuthor => 'Tên: ';

  @override
  String get brithday => 'Ngày sinh: ';

  @override
  String get occupation => 'Nghề nghiệp: ';
}
