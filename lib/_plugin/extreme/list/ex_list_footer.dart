import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

class ExListFooter {
  static getFooter(ApiDefinition apiDefinition) {
    if (apiDefinition.headerLeft == null && apiDefinition.footerLeft == null) {
      return Container();
    }
    
    return Column(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 14.0, right: 14.0, bottom: 4.0, top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Help",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
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
