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
        .get('/comments/${client.id}', queryParameters: {'page': page});

    return List.from(res.data['data'].map((e) {
      final user = Commentator()
        ..id = e['user_id'].toString()
        ..name = e['user']['name']
        ..avatar = e['user']?['avatar'];
      return XComment()
        ..body = e['body']
        ..id = e['id'].toString()
        ..commentator = user
        ..createdAt = e['created_at'];
    }));
  }

  Future<XComment> storeComment(
      {required String commentableId, required String body}) async {
    final res = await _dio.post('/comments',
        data: {'body': body, 'commentable_id': commentableId});
    final data = res.data['data'];
    return XComment()
      ..id = data['id'].toString()
      ..body = body
      ..createdAt = data['created_at'];
  }

  Future<void> deleteComment(String commentId) async {
    await _dio.delete('/comments/$commentId');
  }

  Future<XComment?> uploadFile(String commentableId) async {
    final resFiles = await FilePicker.platform.pickFiles(type: FileType.image);
    if (resFiles == null) return null;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(resFiles.files.first.path!),
      'commentable_id': commentableId,
    });

    final res = await _dio.post('/comments',
        data: formData, options: Options(followRedirects: false));

    final data = res.data['data'];
    return XComment()
      ..id = data['id'].toString()
      ..body = data['body']
      ..createdAt = data['created_at'];
  }
}
