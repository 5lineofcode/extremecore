import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:extremecore/core.dart';

class ExImageUpload extends StatefulWidget {
  final String id;
  final String value;

  ExImageUpload({
    @required this.id,
    this.value,
  });

  @override
  ExImageUploadState createState() => ExImageUploadState();
}

class ExImageUploadState extends State<ExImageUpload> {
  String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.value;

    if (imageUrl == null) {
      imageUrl = "";
    }
    Input.set(widget.id, imageUrl);
  }

  uploadImage(File image) async {
    if (image == null) {
      print("Image can't be null");
      return;
    }
    String base64Image = base64Encode(image.readAsBytesSync());

    print(base64Image);
    var response =
        await http.post(Session.getApiUrl(endpoint: "upload"), body: {
      "base64_image": base64Image,
    });

    print("Image Upload Response:");
    print(response.body);

    var obj = json.decode(response.body);
    print(obj);

    if (this.mounted) {
      setState(() {
        imageUrl = obj["image_url"];

        Input.set(widget.id, imageUrl);
        Navigator.of(context).pop();
      });
    }
  }

  Future browseCamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    setState(() {
      uploadImage(image);
    });
  }

  Future browseGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    setState(() {
      uploadImage(image);
    });
  }

  Future showBottomSheet(context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () {
                      browseCamera();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () {
                    browseGallery();
                  },
                ),
              ],
            ),
          );
        });
  }

  getImagePreview() {
    if (imageUrl != "" && imageUrl != null && imageUrl != "null") {
      return FadeInImage(
        placeholder: AssetImage("assets/images/loading.gif"),
        image: NetworkImage(Session.getAssetUrl(imageUrl)),

      );
    }

    return Image.asset("assets/images/no_photo.jpg");
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != "") {
      print("Loading Image From:");
      print(Session.getAssetUrl(imageUrl));
    }

    if (imageUrl != "") {
      print("Loading Image From:");
      print(Session.getAssetUrl(imageUrl));
    }

    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            showBottomSheet(context);
          },
          child: Container(
            width: 120.0,
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: getImagePreview(),
          ),
        ),
        Expanded(
          child: Container(
            height: 140.0,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Text(
                  "Maximum file size:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                Text(
                  "10 MB",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Container(
                  height: 6.0,
                ),
                Text(
                  "Format file allowed:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                Text(
                  ".JPG .JPEG .PNG",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Container(
                  height: 6.0,
                ),
                Container(
                  height: 25.0,
                  child: ExButton(
                    label: "Delete",
                    icon: Icons.delete,
                    type: Colors.red,
                    onPressed: () {
                      setState(() {
                        imageUrl = "";
                        Input.set(widget.id, imageUrl);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}