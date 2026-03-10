import 'IView.dart';

abstract class IPresenter<V extends IView> {
    void attachView(V view);
    void detachView();
}