import 'package:massageronsitetestingapp/http/HttpBase.dart';

abstract class IModel {
    void dispose();
    late HttpBase http;
}