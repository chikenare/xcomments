import 'package:xcomments/src/models/commentator.dart';

class XComment {
  late String id, body, createdAt;
  Commentator? commentator;

  bool get isImage => RegExp('.(png|jpg)').hasMatch(body);

  String getFilePath(String urlApi) => '$urlApi/storage/$body';
}
