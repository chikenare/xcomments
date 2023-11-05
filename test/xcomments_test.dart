import 'package:flutter_test/flutter_test.dart';
import 'package:xcomments/src/api/xcomments_api.dart';
import 'package:xcomments/xcomments.dart';

void main() {
  final client = XCommentsClient('testxd',
      urlApi: 'http://192.168.100.21',
      id: 'movies',
      user: User(name: 'Will', token: 'mytokenxdx'));
  final api = XCommentsApi(client);
  test('Test', () async {
    final res = await api.setUser(client.user);
    print('${res?.id} ${res?.name}');
  });
}
