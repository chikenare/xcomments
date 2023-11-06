import 'package:jiffy/jiffy.dart';
import 'package:xcomments/src/models/commentator.dart';

class XComment {
  late String id, body, createdAt;
  int repliesCount = 0;
  Commentator? commentator;
  final List<XComment> replies = [];

  bool get isImage => RegExp('.(png|jpg)').hasMatch(body);

  String getFilePath(String urlApi) => '$urlApi/storage/$body';
  String get getDate =>
      Jiffy.parseFromDateTime(DateTime.parse(createdAt)).fromNow();
}
