import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class Session {
  //User Data
  static String username;
  static int branchId;
  static int idPrivileges;
  static String userLevel = "Owner"; 
  static String email;
  static String password;
  static String mobile;

  static bool isLogin = false;

  static Color themeColor = Color(0xffA40C33);







  //! URL SETTING
  static String host = "";
  static String baseUrl = "$host/public/admin";
  static String apiUrl = "$host/public/api";
  static String publicUrl = "$host/public";

  static String appVersion = "";
  static String lastBuildTime = "";

  static String getAssetUrl(String imageUrl) {
    return "$host/public/" + imageUrl;
  }

  static String getUrl({
    String endpoint = "",
  }) {
    var singleviewmodestr = endpoint.indexOf("?") == -1
        ? "?singleviewmode=true"
        : "&singleviewmode=true";

    if (endpoint.indexOf("singleviewmode") > -1) {
      singleviewmodestr = "";
    }

    return baseUrl + (endpoint != "" ? "/" + endpoint + singleviewmodestr : "");
  }

  static String getApiUrl({
    String endpoint = "",
    List<ParameterValue> params = const [],
  }) {
    var queryString = "";
    if(params.length>0){
      queryString = "?";

      for(var param in params){
        var key = param.key;
        var value = param.value.toString();
        queryString += "$key=$value";
      }
    }

    var url = apiUrl + (endpoint != "" ? "/" + endpoint + queryString: "");
    print("Request URL: " + url);
    return url;
  }

  static bool isDeveloperMode = false;
}


class ParameterValue {
  final String key;
  final dynamic value;
  ParameterValue({
    @required this.key,
    @required this.value,
  });
}