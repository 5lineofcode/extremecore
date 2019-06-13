import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

class ExListHeader {
  static getHeader(ApiDefinition apiDefinition) {

    if(apiDefinition.headerLeft == null && apiDefinition.footerLeft == null){
      return Container();
    }
    
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Title"),
              Text(
                "20 May 2019",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey[200],
          padding: EdgeInsets.all(8.0),
        ),
      ],
    );
  }
}
