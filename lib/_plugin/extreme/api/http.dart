import 'package:extremecore/core.dart';

class ExtremeHttp {
  Future get(String url) async {
    var resp = await dio.get(url).timeout(Duration(seconds: 5),onTimeout: () {
      //On Timeout Handler
      // return Future.sync("computation");
    }).catchError((error) {
      //On Server Error Handler
    }).then((response){
      //On Response Handler
    });


  }
}