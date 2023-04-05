import 'package:flutter/material.dart';
import 'Utilidades.dart';

class API extends ChangeNotifier {
  static var url = "https://"+Utilidades.siteApiSession+"/";
  static var header = {"Content-Type": "application/json"};
}