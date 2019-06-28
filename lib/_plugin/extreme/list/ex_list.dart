import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

class ExList extends StatefulWidget {
  final String title;
  final ApiDefinition apiDefinition;

  final dynamic onTap;

  final dynamic onItemSelected;

  final bool noFloatingActionButton;
  final bool noActionsButton;
  final bool noAppBar;
  final bool noDelete;

  final formPageTemplate;
  final editPageTemplate;

  final dynamic itemBuilder;

  ExList({
    this.title = "",
    @required this.apiDefinition,
    this.onTap,
    this.onItemSelected,
    this.noFloatingActionButton = false,
    this.noActionsButton = false,
    this.noAppBar = false,
    this.noDelete = false,
    this.formPageTemplate,
    this.editPageTemplate,
    this.itemBuilder,
  });

  @override
  _ExListState createState() => _ExListState();
}

class _ExListState extends State<ExList> {
  ApiDefinition apiDefinition;
  RefreshController _refreshController;

  List items = [];
  String nextPageUrl;
  String prevUrl;

  @override
  void initState() {
    super.initState();
    apiDefinition = widget.apiDefinition;
    _refreshController = RefreshController();
    loadData();
  }

  bool isLoading = true;
  void loadData() async {
    setState(() {
      isLoading = true;
    });

    // var obj = await Server.getTable(endpoint: apiDefinition.endpoint);

    var whereQuery = "";
    apiDefinition.where.forEach((key, value) {
      whereQuery = "f_$key=$value";
    });

    whereQuery = whereQuery.length == 0 ? "" : "?$whereQuery";

    var url = Session.apiUrl + "/table/${apiDefinition.endpoint}$whereQuery";
    var response = await dio.get(url);
    var obj = response.data;

    print("ExList LoadData : $url");

    if (this.mounted) {
      setState(() {
        items = obj["data"];
        nextPageUrl = obj["next_page_url"];
        isLoading = false;

        _refreshController.refreshCompleted();
      });
    }
  }

  void _deleteData(item) async {
    var id = item[apiDefinition.primaryKey];
    var url = Session.getApiUrl(
      endpoint: "delete/${apiDefinition.endpoint}/$id",
    );
    await dio.post(url);
  }

  void loadNextPage(url) async {
    print("Loading Data from $url");

    var response = await dio.get(url);
    var obj = response.data;

    print(obj);
    setState(() {
      items += obj["data"];
      nextPageUrl = obj["next_page_url"];

      if (nextPageUrl == null) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    });
  }

  void _onRefresh() {
/*.  after the data return,
use _refreshController.refreshComplete() or refreshFailed() to end refreshing
*/
    loadData();

// Future.delayed(const Duration(milliseconds: 500), () {
//   _refreshController.refreshCompleted();
// });
  }

  void _onLoading() async {
/* 
use _refreshController.loadComplete() or loadNoData() to end loading
*/

    if (nextPageUrl == null) {
      _refreshController.loadComplete();
    } else {
      loadNextPage(nextPageUrl);
    }

// Future.delayed(const Duration(seconds: 500), () {
//   _refreshController.loadNoData();
// });
  }

  void _showSortOptions(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    "Sort By:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.sort),
                    title: Text('Newest Item'),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.sort_by_alpha),
                  title: Text('A - Z'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<bool> confirmDismiss(BuildContext context, String action) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to $action this item?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true); // showDialog() returns true
              },
            ),
          ],
        );
      },
    );
  }

  getDefaultItemTemplate(context, item, index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder(context, item, index);
    }

    return Card(
      child: Column(
        children: <Widget>[
          ExListHeader.getHeader(widget.apiDefinition),
          ListTile(
            leading: apiDefinition.leadingPhotoIndex != null
                ? Container(
                    width: 60.0,
                    height: 60.0,
                    child: FadeInImage(
                      placeholder:
                          AssetImage("assets/gif/saji_logo_only_black.gif"),
                      image: item[apiDefinition.leadingPhotoIndex] != null
                          ? NetworkImage(
                              "${Session.publicUrl}/${item[apiDefinition.leadingPhotoIndex]}")
                          : AssetImage("assets/images/no_pict.png"),
                    ),
                  )
                : null,
            title: apiDefinition.titleIndex != null
                ? Text(item[apiDefinition.titleIndex].toString())
                : null,
            subtitle: apiDefinition.subtitleIndex != null
                ? Text(item[apiDefinition.subtitleIndex].toString())
                : null,
          ),
          ExListFooter.getFooter(widget.apiDefinition),
        ],
      ),
      semanticContainer: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.noAppBar
          ? null
          : AppBar(
              title: Text(widget.title),
              actions: widget.noActionsButton == true
                  ? []
                  : [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            _showSortOptions(context);
                          },
                          child: Icon(Icons.sort),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      )
                    ]),
      floatingActionButton: widget.noFloatingActionButton == true
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!

                Input.set("selectedId", null);
                if (widget.formPageTemplate != null) {
                  Page.show(context, widget.formPageTemplate).then((hook) {
                    loadData();
                    setState(() {
                      items = [];
                    });
                  });
                } else {
                  SweetAlert.show(
                    context,
                    title:
                        "Please add Property AddPageTemplate to ExList declaration!",
                  );
                }
              },
              child: Icon(FontAwesomeIcons.plus),
              backgroundColor: Colors.grey[800],
            ),
      body: isLoading
          ? Center(child: Text("Loading"))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  complete: Wrap(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Success",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];

                    if (widget.noDelete) {
                      return getDefaultItemTemplate(context, item, index);
                    }
                    
                    return Dismissible(
                      key: Key(item[apiDefinition.primaryKey].toString()),
                      confirmDismiss: (DismissDirection dismissDirection) {
                        confirmDismiss(context, 'delete').then((bool value) {
                          if (value) {
                            SweetAlert.show(context,
                                style: SweetAlertStyle.success,
                                title: "Success delete data");
                            setState(
                              () {
                                _deleteData(item);
                                items.removeAt(index);
                              },
                            );
                          }
                        });
                      },
                      onDismissed: (direction) {},
                      background: Container(color: Colors.red),
                      child: InkWell(
                        onTap: () {
                          if (widget.onItemSelected != null) {
                            widget.onItemSelected(item);
                            // Navigator.of(context).pop();
                            return;
                          }

                          if (widget.onTap != null) {
                            widget.onTap();
                            return;
                          }

                          if (widget.formPageTemplate != null) {
                            Input.set("selectedId",
                                item[widget.apiDefinition.primaryKey]);
                            Page.show(context, widget.formPageTemplate)
                                .then((hook) {
                              loadData();
                              setState(() {
                                items = [];
                              });
                            });
                          } else {
                            SweetAlert.show(
                              context,
                              title:
                                  "Please add Property FormPageTemplate to ExList declaration!",
                            );
                          }
                        },
                        child: getDefaultItemTemplate(context, item, index),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
