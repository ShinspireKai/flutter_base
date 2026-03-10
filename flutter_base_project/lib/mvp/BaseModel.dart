import 'package:massageronsitetestingapp/http/HttpBase.dart';

import 'IModel.dart';

abstract class BaseModel implements IModel {

  late HttpBase http;

  @override
  void dispose() {
    http.clear();
  }
}