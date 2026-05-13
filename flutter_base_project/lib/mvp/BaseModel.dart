import 'IModel.dart';
import 'IPresenter.dart';
import 'IView.dart';

/// BaseModel — nền tảng cho mọi Model trong MVP
/// Open/Closed: kế thừa để mở rộng, không cần sửa class này
abstract class BaseModel implements IModel {
  late HttpBase http;

  @override
  void dispose() {}
}
