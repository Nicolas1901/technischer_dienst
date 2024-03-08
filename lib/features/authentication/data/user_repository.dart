import 'package:pocketbase/pocketbase.dart';

import '../domain/user.dart';

class UserRepository {
  final PocketBase pb;

  UserRepository({required this.pb});

  Future<User> authenticateUser(
      {required String usernameOrEmail, required String password}) async {
    await pb.collection('user').authWithPassword(usernameOrEmail, password);

    final AuthStore authStore = pb.authStore;

    return User(
        username: authStore.model.getStringValue('username'),
        profileImage: authStore.model.getStringValue('avatar'),
        email: authStore.model.getStringValue('email'),
        authStore: authStore);
  }

  logoutUser() {
    pb.authStore.clear();
  }
}
