import 'package:flutter/material.dart';
import 'package:xcomments/src/api/xcomments_api.dart';
import 'package:xcomments/src/models/commentator.dart';
import 'package:xcomments/src/models/reply_data.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/xcomments.dart';

class AppState extends ChangeNotifier {
  AppState({required this.client});
  final XCommentsClient client;

  Commentator? user;

  XCommentsApi get _api => XCommentsApi(client);
  final List<XComment> comments = [];
  bool loading = true, hasComments = true;
  ReplyData? _reply;
  int page = 0;

  ReplyData? get reply => _reply;
  set reply(ReplyData? value) {
    _reply = value;
    notifyListeners();
  }

  void initComments() async {
    try {
      await setUser();
      await getComments();
    } catch (e) {
      print(e.toString());
    }
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

  Future<void> geReplies(String id) async {
    final res = await _api.getReplies(id, page: 1);
    comments.firstWhere((e) => e.id == id).replies.addAll(res);
    notifyListeners();
  }

  Future<void> storeComment(String body) async {
    final isReply = _reply != null;
    final res = await _api.storeComment(
      channel: isReply ? _reply!.id : client.channel,
      body: body,
      isReply: isReply,
    );
    res.commentator = Commentator()
      ..id = user!.id
      ..avatar = user!.avatar
      ..name = user!.name;
    isReply
        ? comments.firstWhere((e) => e.id == _reply?.id).replies.add(res)
        : comments.insert(0, res);
    notifyListeners();
  }

  void addComment(XComment comment) {
    final commentator = Commentator()
      ..id = user!.id
      ..avatar = user!.avatar
      ..name = user!.name;
    comment.commentator = commentator;
    _reply == null
        ? comments.insert(0, comment)
        : comments.firstWhere((e) => e.id == _reply!.id).replies.add(comment);

    notifyListeners();
  }
}
