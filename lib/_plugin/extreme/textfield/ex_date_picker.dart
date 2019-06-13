import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

class ExDatePicker extends StatefulWidget {
  final String id;
  final String label;
  final IconData icon;
  final String value;
  final BuildContext context;
  
  final bool enableDatePicker;

  ExDatePicker({
    @required this.id,
    @required this.label,
    this.icon = Icons.note,
    this.value,
    @required this.context,
    this.enableDatePicker = true,
  });

  @override
  _ExDatePickerState createState() => _ExDatePickerState();
}

class _ExDatePickerState extends State<ExDatePicker> {
  @override
  void initState() {
    super.initState();

    if (widget.value == null) {
      Input.set(widget.id, "");
    } else {
      Input.set(widget.id, widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExTextField(
      id: widget.id,
      label: widget.label,
      icon: widget.icon,
      useBorder: true,
      useIcon: true,
      enable: false,
      value: widget.value != null ? widget.value : "",
      onContainerTap: () { 
        if(widget.enableDatePicker==false){
          return;
        }
        DatePicker.showDatePicker(context,
            theme: DatePickerTheme(),
            showTitleActions: true,
            minTime: DateTime(2018, 3, 5),
            maxTime: DateTime(2019, 6, 7), onChanged: (date) {
          Input.set(widget.id, date);
          Input.controllerList[widget.id].text = date.toString();
          print('change $date');
        }, onConfirm: (date) {
          Input.set(widget.id, date);
          Input.controllerList[widget.id].text = date.toString();
          print('confirm $date');
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
    );
  }
}
