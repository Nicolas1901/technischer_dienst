import 'package:pocketbase/pocketbase.dart';

import '../domain/user.dart';

class UserRepository{
  final PocketBase pb;

  UserRepository({required this.pb});

 /* Future<User> authenticateUser({required String usernameOrEmail, required String password}) async {
    RecordAuth recordAuth = await pb.collection('user').authWithPassword(usernameOrEmail, password);

  }*/
}