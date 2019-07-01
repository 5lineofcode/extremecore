import 'dart:async';
import 'package:extremecore/core.dart';

var cachedEndpoint = [
  "product",
  "product_category",
  "product_station",
];

class ExtremeHttp {
  Future<dynamic> get(String url) async {

    /*
    TODO: Check if endpoint need update or not, if not just return sqlite Value
    TODO: Use Model and Cached it on Sqlite at Client Side, and New Database Called EndpointStatus to Save All Endpoint Version
    TODO: if Cached Endpoint Version is Different From Endpoint Status, set CachedModel needUpdate field to true
    TODO: if not, just return value from sqlite
    TODO: if no endpoint found on the model, do normal http Request and Response
    */

    print("Request: " + url);

    try {
      // dio.options.sendTimeout = 100;
      // dio.options.receiveTimeout = 100;

      var response = await dio.get(url);

      handleUserDefinedError(response.data);

      return Future.value(response.data);
    } catch (error) {
      handleDioError(error);
      return Future.value("ERROR");
    }
  }

  handleUserDefinedError(responseData) {
    print(":: UserDefined Error ::");
    if (responseData["error"] == true) {
      switch (responseData["error_code"]) {
        case "BRANCHED_ENDPOINT":
          print(responseData["message"]);
          break;
        default:
          print("Undefined UserDefined Error");
          print(responseData);
          break;
      }
    }
  }

  handleDioError(error) {
    print(":: Dio Error ::");
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
  }
}
