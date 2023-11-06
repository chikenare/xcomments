import 'package:xcomments/src/models/user.dart';

class XCommentsClient {
  final String apiKey, urlApi, channel;
  final User user;

  XCommentsClient(
    this.apiKey, {
    required this.urlApi,
    required this.channel,
    required this.user,
  });
}
