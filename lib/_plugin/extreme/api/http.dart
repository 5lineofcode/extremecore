import 'dart:async';
import 'package:extremecore/core.dart';

var cachedEndpoint = [
  "product",
  "product_category",
  "product_station",
];

class ExtremeHttp {
  int maxRetryCount = 3;

  ExtremeHttp() {
    dio.options.connectTimeout = 5000;
    // dio.options.sendTimeout = 1000;
    // dio.options.receiveTimeout = 1000;
  }

  Future<dynamic> get(
    String url, {
    bool isCached = false,
  }) async {
    bool requestDone = false;
    int requestCount = 0;
    var returnedResponse;

    /*
    TODO: Check if endpoint need update or not, if not just return sqlite Value
    TODO: Use Model and Cached it on Sqlite at Client Side, and New Database Called EndpointStatus to Save All Endpoint Version
    TODO: if Cached Endpoint Version is Different From Endpoint Status, set CachedModel needUpdate field to true
    TODO: if not, just return value from sqlite                                            
    */

    while (requestDone == false) {
      print("GET: " + url);
      try {
        var response = await dio.get(url);
        handleUserDefinedError(response.data);
        requestDone = true;
        returnedResponse = response.data;
      } catch (error) {
        // String prodHost = "http://192.168.6.234/sajiweb";
        // String devHost = "http://192.168.43.82/sajiweb";

        // Session.host = "http://192.168.6.333/sajiweb";
        requestCount++;
        if (requestCount <= maxRetryCount) {
          print("Retry Connection To: $url   $requestCount/$maxRetryCount");
        } else {
          handleDioError(error);
          requestDone = true;
          returnedResponse = null;
        }
      }
    }

    return Future.value(returnedResponse);
  }

  Future<dynamic> post(String url, dynamic postData) async {
    bool requestDone = false;
    int requestCount = 0;
    var returnedResponse;

    // if(isMirrorServer){
    //   Alert.show(context, message: "Can't Post New Data on Mirror Server");
    //   return;
    // }

    while (requestDone == false) {
      print("----------------");
      print("POST: " + url);
      print("PostData: ");
      print(postData);
      print("################");
      
      try {
        var response = await dio.post(url, data: postData);
        handleUserDefinedError(response.data);
        requestDone = true;
        returnedResponse = response.data;

        print("PostResponse: ");
        print(returnedResponse);
        print("~~~~~~~~~~~~~~");
      } catch (error) {
        requestCount++;
        if (requestCount <= maxRetryCount) {
          print("Retry Connection To: $url   $requestCount/$maxRetryCount");
        } else {
          handleDioError(error);
          requestDone = true;
          returnedResponse = null;
        }
      }
    }

    return Future.value(returnedResponse);
  }

  handleUserDefinedError(responseData) {
    if (responseData["error"] == true) {
      switch (responseData["error_code"]) {
        case "BRANCHED_ENDPOINT":
          print(responseData["message"]);
          print(responseData);
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
        default:
          errorDescription = "### UNDEFINED ERROR ###";
          errorDescription += error;
          break;
      }
      print(errorDescription);
    }
  }
}
