import 'package:extremecore/core.dart';

class ApiDefinition {
  final String endpoint;
  final String primaryKey;
  final String leadingPhotoIndex;
  final String titleIndex;
  final String subtitleIndex;

  //aditional field
  final String headerLeft;
  final String headerRight;

  final String footerLeft;
  final String footerRight;

  //paging & filter & sorting
  final int pageCount;

  ApiDefinition({
    @required this.endpoint,
    @required this.primaryKey,
    @required this.leadingPhotoIndex,
    @required this.titleIndex,
    @required this.subtitleIndex,

    //additional
    this.headerLeft,
    this.headerRight,
    this.footerLeft,
    this.footerRight,
    this.pageCount = 10,
  });
}
