import 'package:extremecore/core.dart';

class Api {
  String endpoint = "no-endpoint";
  PostResponse postResponse;

  parseResponse(response) {
    if (response == null) {
      print("Error, Server Side ERROR");
      return null;
    }

    var obj;
    try {
      obj = json.decode(response.body);
    } catch ($e) {
      print("Can't Parse to JSON");
      print(response.body);
    }
    return obj;
  }

  formatFields(fields) {
    fields.forEach((key, value) {
      fields[key] = value.toString();
    });
    return fields;
  }

  Future customUrl(url) async {
    //!Get Table API
    await dio.get(url);
  }

  Future getTable() async {
    //!Get Table API
    var url = Session.getApiUrl(endpoint: "table/${this.endpoint}");
    var response = await dio.get(url);
    return Future.value(parseResponse(response));
  }

  Future getAll() async {
    //!Get All Data Api
    var url = Session.getApiUrl(endpoint: "get-all/${this.endpoint}");
    var response = await dio.get(url);
    return Future.value(parseResponse(response));
  }

  Future get(id) async {
    //!Get Single Data Api
    var url = Session.getApiUrl(endpoint: "get/${this.endpoint}/$id");
    var response = await dio.get(url);
    return Future.value(parseResponse(response));
  }

  Future<PostResponse> create(fields) async {
    //!Create Data API
    var url = "${Session.host}public/api/create/${this.endpoint}";

    try {
      var response = await dio.post(url, data: formatFields(fields));
      var createResponse = PostResponse.fromJson(parseResponse(response));
      return Future.value(createResponse);
    } catch ($e) {
      print("Request URL :" + url);
      print("Api CREATE ERROR >> SERVER SIDE ERROR | CAN'T PARSE JSON");
      return Future.value(null);
    }
  }

  Future<PostResponse> update(fields) async {
    //!Update Data API
    var url = "${Session.host}public/api/update/${this.endpoint}";

    try {
      var response = await dio.post(url, data: formatFields(fields));
      var updateResponse = PostResponse.fromJson(parseResponse(response));
      return Future.value(updateResponse);
    }
    catch($e){
      print("Request URL :" + url);
      print("Api UPDATE ERROR >> SERVER SIDE ERROR | CAN'T PARSE JSON");
      return Future.value(null);
    }
  }

  Future<PostResponse> delete(id) async {
    //!Delete Data Ap
    var url = Session.getApiUrl(endpoint: "delete/${this.endpoint}/$id");
    var response = await dio.post(url);

    var postResponse = PostResponse.fromJson(parseResponse(response));
    return Future.value(postResponse);
  }
}

class CustomApi {
  String endpoint = "no-endpoint";
  String method = "no-method";

  Future post(fields) async {
    //!Create Data API
    var url =
        Session.getApiUrl(endpoint: "custom/${this.endpoint}/${this.method}");
    await dio.post(url, data: fields);
  }
}
