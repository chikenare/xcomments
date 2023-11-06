import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xcomments/src/models/commentator.dart';
import 'package:xcomments/src/models/user.dart';
import 'package:xcomments/src/models/xcomment.dart';
import 'package:xcomments/src/models/xcomments_client.dart';

class XCommentsApi {
  XCommentsClient client;
  XCommentsApi(this.client);

  Dio get _dio => Dio(BaseOptions(
        baseUrl: '${client.urlApi}/api',
        headers: {
          'api-key': client.apiKey,
          'Authorization': 'Bearer ${client.user.token}'
        },
        validateStatus: (status) {
          return status! < 500;
        },
        followRedirects: false,
      ));

  Future<Commentator?> setUser(User user) async {
    final res = await _dio.post('/user', data: {
      'name': user.name,
      'avatar': user.avatar,
      'device': 'App',
      'token': user.token
    });
    final data = res.data['data']['user'];
    return Commentator()
      ..id = data['id'].toString()
      ..avatar = data['avatar']
      ..name = data['name'];
  }

  Future<List<XComment>> getComments(
    XCommentsClient client, {
    int page = 1,
  }) async {
    final res = await _dio
        .get('/comments/${client.channel}', queryParameters: {'page': page});
    final comments = _setComments(res.data['data']);
    return comments;
  }

  Future<List<XComment>> getReplies(
    String id, {
    int page = 1,
  }) async {
    final res = await _dio
        .get('/comments/$id', queryParameters: {'page': page, 'reply': true});
    final comments = _setComments(res.data['data']);
    return comments;
  }

  List<XComment> _setComments(List data) {
    return List.from(data.map((e) {
      final user = Commentator()
        ..id = e['user_id'].toString()
        ..name = e['user']['name']
        ..avatar = e['user']?['avatar'];
      return XComment()
        ..body = e['body']
        ..id = e['id'].toString()
        ..commentator = user
        ..repliesCount = e['replies_count'] ?? 0
        ..createdAt = e['created_at'];
    }));
  }

  Future<XComment> storeComment({
    required String channel,
    required String body,
    required bool isReply,
  }) async {
    final Map<String, String> params = {};
    if (isReply) params.addAll({'reply': 'true'});
    final res = await _dio.post('/comments',
        data: {'body': body, 'channel': channel}, queryParameters: params);
    final data = res.data['data'];
    return XComment()
      ..id = data['id'].toString()
      ..body = body
      ..createdAt = data['created_at'];
  }

  Future<void> deleteComment(String commentId) async {
    await _dio.delete('/comments/$commentId');
  }

  Future<XComment?> uploadFile(String channel, {bool? isReply}) async {
    final resFiles = await FilePicker.platform.pickFiles(type: FileType.image);
    if (resFiles == null) return null;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(resFiles.files.first.path!),
      'channel': channel,
    });

    final Map<String, dynamic> params = {};
    if (isReply ?? false) params.addAll({'reply': true});

    final res = await _dio.post('/comments',
        data: formData,
        options: Options(followRedirects: false),
        queryParameters: params);

    final data = res.data['data'];
    return XComment()
      ..id = data['id'].toString()
      ..body = data['body']
      ..createdAt = data['created_at'];
  }
}
