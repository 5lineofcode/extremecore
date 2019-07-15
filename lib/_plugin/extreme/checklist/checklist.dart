import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

/*
? Developer Note
Always Set DefaultValue of 
Input.set(widget.id, "");
Input.set(widget.id, null);
Input.set(widget.id, []);
*/

/*
id  = id widget, digunakan untuk mengambil dan mengatur nilai item apa saja yang dipilih
height = sebaiknya di isi, untuk saat ini belum bisa menyesuaikan isi dari content :(
*/

//push again
class CheckList extends StatefulWidget {
  final String id;
  final String label;
  final ApiDefinition apiDefinition;
  final double height;
  CheckList({
    @required this.id,
    @required this.label,
    @required this.apiDefinition,
    this.height = 400.0,
  });

  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  ApiDefinition apiDefinition;

  var items = [];

  loadData() async {
    List<ParameterValue> params = [];
    params.add(ParameterValue(
      key: "page_count",
      value: 10,
    ));
    var url = Session.getApiUrl(
      endpoint: "table/${apiDefinition.endpoint}",
      params: params,
    );

    var response = await http.get(url);
    var obj = response;

    if (this.mounted) {
      setState(() {
        items = obj["data"];

        for (var item in items) {
          item["checked"] = false;
        }
      });
    }
  }

  saveInputtedData() {
    var selectedItems = [];
    for (var item in items) {
      if (item["checked"] == true) {
        selectedItems.add(item);
      }
    }
    Input.set(widget.id, selectedItems);
  }

  @override
  void initState() {  
    super.initState();
    Input.set(widget.id, []);
    apiDefinition = widget.apiDefinition;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
      return Center(child: Text("Loading"));
    }

    List<Widget> columnItems = [];

    var header = Container(
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.black,
            padding: EdgeInsets.all(6.0),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              setState(() {
                items.forEach((item) {
                  item["checked"] = false;
                });
              });
              saveInputtedData();
            },
            child: Container(
              color: Colors.orange,
              padding: EdgeInsets.all(6.0),
              child: Text(
                "UnSelect All",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 10.0,
          ),
          InkWell(
            onTap: () {
              setState(() {
                items.forEach((item) {
                  item["checked"] = true;
                });
              });
              saveInputtedData();
            },
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.all(6.0),
              child: Text(
                "Select All",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    columnItems.add(header);

    for (var item in items) {
      var newWidget = InkWell(
        onTap: () {
          setState(() {
            item["checked"] = item["checked"] == true ? false : true;
            saveInputtedData();
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 6.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListTile(
                  // leading: FlutterLogo(),
                  title: Text(item[apiDefinition.titleIndex]),
                  // subtitle: Text("Sub Title"),
                ),
              ),
              Container(
                width: 50.0,
                child: Checkbox(
                  value: item["checked"],
                  onChanged: (isChecked) {
                    setState(() {
                      item["checked"] = isChecked;
                      saveInputtedData();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
      columnItems.add(newWidget);
    }

    return Container(
      padding: EdgeInsets.all(6.0),
      color: Colors.red[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnItems,
      ),
    );
  }
}
