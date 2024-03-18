import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/Appuser.dart';

class UserRepository {
  final FirebaseAuth fireAuth;
  final FirebaseFirestore db;

  UserRepository({required this.db, required this.fireAuth});

  Future<AppUser> signIn(String email, String password) async {
    try {
      final credentials = await fireAuth.signInWithEmailAndPassword(
          email: email, password: password);
      
      final data = await db.collection('userAccounts').doc(credentials.user!.uid).get();

      return AppUser(uid: credentials.user!.uid,
          username: data['username'] as String,
          profileImage: data['profileImage'] as String,
          email: credentials.user!.email ?? "",
         );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
      try {
        await fireAuth.signOut();
      } catch (e) {
        rethrow;
      }
  }

  resetPassword() {
    //TODO implement resetPassword
  }

  Future<DocumentSnapshot> loadUserData(String uid) async {
    try{
      return await db.collection('userAccounts').doc(uid).get();
    } catch(e){
      rethrow;
    }
  }

}
