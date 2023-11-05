class Commentator {
  late String id, name;
  String? avatar;

  String getAvatar() => 'https://ui-avatars.com/api/?name=$name';
}
