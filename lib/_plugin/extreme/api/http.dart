import 'dart:async';
import 'package:extremecore/core.dart';
import 'package:flutter/material.dart';

class ExtremeHttp {
  Completer completer = new Completer();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future get(String url) async {
    print("Request: " + url);

    try {
      dio.options.sendTimeout = 100;
      dio.options.receiveTimeout = 100;

      var response = await dio.get(url);

      print("Response:::");
      print("StatusCode : ${response.statusCode}");
      print("----");
      return;
    } catch (error) {
      if (error is DioError) {
        var errorDescription;
        switch (error.type) {
          case DioErrorType.CANCEL:
            errorDescription = "Request to API server was cancelled";
            break;
          case DioErrorType.CONNECT_TIMEOUT:
            errorDescription = "Connection timeout with API server";
            break;
          case DioErrorType.DEFAULT:
            errorDescription =
                "Connection to API server failed due to internet connection";
            break;
          case DioErrorType.RECEIVE_TIMEOUT:
            errorDescription = "Receive timeout in connection with API server";
            break;
          case DioErrorType.SEND_TIMEOUT:
            errorDescription = "Send timeout in connection with API server";
            break;
          case DioErrorType.RESPONSE:
            errorDescription =
                "Received invalid status code: ${error.response.statusCode}";
            break;
        }
        print(errorDescription);
      }
      return;
    }
  }
}
