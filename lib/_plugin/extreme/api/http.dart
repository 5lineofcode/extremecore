import 'dart:async';
import 'package:extremecore/core.dart';
import 'package:extremecore/view/page/order/example_list.dart';
import 'package:flutter/material.dart';

class ExtremeHttp {
  Completer completer = new Completer();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future get(String url) async {
    print("Request: " + url);

    try {

      var response = await dio.get(url);

      if (response == null) {
        print("RTO :(");
        return;
      }

      print("Response:::");
      print("StatusCode : ${response.statusCode}");
      print("----");
      return;
    } catch (error) {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.CONNECT_TIMEOUT:
            print("CONNECTION_TIMEOUT");
            break;
          default:
            print(error.toString());
            break;
        }
      }
      print("Response is Null, Server ERROR");
      return;
    }
  }
}
