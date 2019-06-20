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
class CheckList extends StatefulWidget {
  final String id;
  final ApiDefinition apiDefinition;
  final double height;
  CheckList({
    @required this.id,
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
    print("Loading Data from $url");

    var response = await dio.get(url);

    var obj;
    try {
      obj = json.decode(response.data);
    } catch (ex) {
      print("Can't be decoded to Object");
      print("Response Body:");
      print(response.data);
      return;
    }

    print(obj);
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
    return Container(
      padding: EdgeInsets.all(20.0),
      height: 400.0,
      color: Colors.grey[200],
      child: items.length == 0
          ? Center(child: Text("Loading"))
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];

                return Transform.scale(
                  scale: 0.8,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        item["checked"] =
                            item["checked"] == true ? false : true;
                        saveInputtedData();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
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
                  ),
                );
              },
            ),
    );
  }
}
