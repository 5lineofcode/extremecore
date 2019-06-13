
import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

class Input {
  static Map<String, dynamic> valueList = HashMap();
  static Map<String, TextEditingController> controllerList = HashMap();

  static get(String id) {
    return valueList[id];
  }

  static set(String id, dynamic value) {
    valueList[id] = value;
  }

  static setAndUpdate(String id, dynamic value) {
    controllerList[id].text = value;
    // valueList[id] = value;
  }

  static setThousandSeparator(double number) {
    final formatter = NumberFormat("###,###.##", "id-ID");
    return formatter.format(number);
  }

  static getValueOnEdit(key, isEdit) {
    if (isEdit) {
      return Input.get(key).toString();
    } else {
      return null;
    }
  }
}
