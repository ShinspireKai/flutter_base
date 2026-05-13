/// Interface cho Presenter trong MVP pattern
/// Single Responsibility: Presenter chỉ xử lý presentation logic
abstract class IPresenter {
  void attachView(dynamic view);
  void detachView();
}
