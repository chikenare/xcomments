import 'package:flutter/material.dart';
import 'package:xcomments/src/api/xcomments_api.dart';
import 'package:xcomments/src/models/commentator.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/xcomments.dart';

class AppState extends ChangeNotifier {
  AppState({required this.client});
  final XCommentsClient client;

  Commentator? user;

  XCommentsApi get _api => XCommentsApi(client);
  final List<XComment> comments = [];
  bool loading = true, hasComments = true;
  int page = 0;

  void initComments() async {
    await setUser();
    await getComments();
  }

  Future<void> setUser() async {
    user = await _api.setUser(client.user);
  }

  Future<void> getComments() async {
    if (!hasComments) return;
    page++;
    final res = await _api.getComments(client, page: page);
    if (res.isEmpty) hasComments = false;
    loading = false;
    comments.addAll(res);
    notifyListeners();
  }

  Future<void> storeComment(String body) async {
    final res = await _api.storeComment(commentableId: client.id, body: body);
    final commentator = Commentator()
      ..id = user!.id
      ..avatar = user!.avatar
      ..name = user!.name;
    comments.insert(0, res..commentator = commentator);
    notifyListeners();
  }

  void addComment(XComment comment) {
    final commentator = Commentator()
      ..id = user!.id
      ..avatar = user!.avatar
      ..name = user!.name;
    comments.insert(0, comment..commentator = commentator);
    notifyListeners();
  }
}
