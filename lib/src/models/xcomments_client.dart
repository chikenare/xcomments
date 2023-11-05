import 'package:xcomments/src/models/user.dart';

class XCommentsClient {
  final String apiKey, urlApi, id;
  final User user;

  XCommentsClient(
    this.apiKey, {
    required this.urlApi,
    required this.id,
    required this.user,
  });
}
