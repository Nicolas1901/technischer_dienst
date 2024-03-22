import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../authentication/domain/Appuser.dart';

class CreateUserRepository{

  static Future<UserCredential?> createNewUser(
      {required AppUser user, required String tmpPassword}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);

    try {

      final credentials = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: user.email, password: tmpPassword);
      return credentials;

    } on Exception catch (e) {
      rethrow;
    }

    app.delete();
  }
}