import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

/*
Need Feature
Select Where
*/
class PostResponse {
  bool isSuccess;
  String message;

  PostResponse({
    this.isSuccess,
    this.message,
  });

  static PostResponse fromJson(json) {
    print("post Response:");
    print(json);

    return PostResponse(
      isSuccess: (json["is_success"] as bool),
      message: json["message"],
    );
  }
}

class Server {
  static Future<PostResponse> create({
    String endpoint,
    dynamic body,
  }) async {
    var url = Session.getApiUrl(
      endpoint: "create/$endpoint",
    );

    var response = await dio.post(url, data: body);

    var obj;
    try {
      obj = json.decode(response.data);
      print("Response:");
      print(obj);
      return Future.value(PostResponse.fromJson(obj));
    } catch (ex) {
      print("Can't convert json to object");
      print("Response Body:");
      print(response.statusCode);
      print(response.data);
      return Future.value(PostResponse.fromJson({
        "is_success": "false",
        "message": "Server ERROR, check PHP Script Response for $url",
      }));
    }
  }

  static Future<PostResponse> update({
    String endpoint,
    dynamic body,
  }) async {
    var url = Session.getApiUrl(
      endpoint: "update/$endpoint",
    );

    var response = await dio.post(url, data: body);

    var obj;
    try {
      obj = json.decode(response.data);
      print("Response:");
      print(obj);
      return Future.value(PostResponse.fromJson(obj));
    } catch (ex) {
      print("Can't convert json to object");
      print("Response Body:");
      print(response.statusCode);
      print(response.data);
      return Future.value(PostResponse.fromJson({
        "is_success": "false",
        "message": "Server ERROR, check PHP Script Response for $url",
      }));
    }
  }

  static dynamic get({
    String endpoint,
    int id,
  }) async {
    var url = Session.getApiUrl(
      endpoint: "get/$endpoint/$id",
    );

    var response = await dio.get(url);

    var obj;
    try {
      obj = json.decode(response.data);

      print("-----");
      print("Loaded Data:");
      print(obj);
      print("-----");

      return obj;
    } catch (ex) {
      print("Can't convert json to object");
      print("Response Body:");
      print(response.statusCode);
      print(response.data);
    }

    var postResponse = PostResponse.fromJson({
      "is_success": "false",
      "message": "Server ERROR, check PHP Script Response for $url",
    });

    return Future.value(postResponse);
  }

  static dynamic getTable({
    String endpoint,
    int id,
  }) async {
    List<ParameterValue> params = [];
    params.add(ParameterValue(
      key: "page_count",
      value: 10,
    ));

    var url = Session.getApiUrl(
      endpoint: "table/$endpoint",
      params: params,
    );

    var response = await dio.get(url);

    var obj;
    try {
      obj = json.decode(response.data);
      print("-----");
      print("Loaded Data:");
      print(obj);
      print("-----");

      return obj;
    } catch (ex) {
      print("Can't convert json to object");
      print("Response Body:");
      print(response.statusCode);
      print(response.data);
    }

    return Future.value(obj);
  }
}

class Alert {
  static showSuccess({
    BuildContext context,
    String title,
    String message,
    dynamic onOk,
    dynamic onCancel,
  }) {
    SweetAlert.show(
      context,
      title: title,
      subtitle: message,
      style: SweetAlertStyle.success,
      onPress: (isConfirmed) {},
    );
    return;
  }

  // static showError(context, title, message, onConfirmed, onUnconfirmed) {

  static showError({
    BuildContext context,
    String title,
    String message,
    dynamic onOk,
    dynamic onCancel,
  }) {
    SweetAlert.show(
      context,
      title: title,
      subtitle: message,
      style: SweetAlertStyle.error,
      onPress: (isConfirmed) {
        if (isConfirmed) {
          if (onOk != null) {
            onOk();
          }

          if (onCancel != null) {
            onCancel();
          }
        }
      },
    );
  }
}

class Loading {
  static show() {
    return Container(
      child: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
