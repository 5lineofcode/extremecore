import 'package:extremecore/_plugin/extreme/location_picker/ex_location_picker.dart';
import 'package:extremecore/core.dart';
import 'package:extremecore/view/page/swiper-example/swiper_example.dart';
import 'package:extremecore/view/page/timeline-example/timeline.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExButton(
              label: "Timeline Example",
              icon: Icons.timeline,
              type: ButtonType.primary,
              onPressed: () {
                Page.show(context, TimelineExamplePage());
              },
            ),
            ExButton(
              label: "Swiper Example",
              icon: Icons.timeline,
              type: ButtonType.primary,
              onPressed: () {
                Page.show(context, SwiperExamplePage());
              },
            ),
            ExLocationPicker(
              id: "location",
              lat: 0,
              lng: 0,
              placeId: "",
            ),
            Text(Input.get("placeId") == null
                ? ""
                : Input.get("placeId").toString()),
            Text(Input.get("lat") == null ? "" : Input.get("lat").toString()),
            Text(Input.get("lng") == null ? "" : Input.get("lng").toString()),
            ExButton(
              label: "GetLocation",
              icon: Icons.timeline,
              type: ButtonType.primary,
              onPressed: () {
                var placeId = Input.get("placeId");
                var lat = Input.get("lat");
                var lng = Input.get("lng");

                print("placeId : $placeId");
                print("lat : $lat");
                print("lng : $lng");
              },
            ),
          ],
        ),
      ),
    );
  }
}
