import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/features/admin/data/create_user_repository.dart';

import '../domain/Appuser.dart';

class UserRepository {
  final FirebaseAuth fireAuth;
  final FirebaseFirestore db;
  late final CollectionReference<AppUser> _usersRef;

  UserRepository({required this.db, required this.fireAuth}){
    _usersRef = db.collection('userAccounts').withConverter(fromFirestore: AppUser.fromFirestore,
        toFirestore: (AppUser user, _) => user.toMap());
  }

  Future<AppUser> signIn(String email, String password) async {
    try {
      final credentials = await fireAuth.signInWithEmailAndPassword(
          email: email, password: password);
      
      final data = await _usersRef.doc(credentials.user!.uid).get();

      return AppUser(uid: credentials.user!.uid,
          username: data['username'] as String,
          profileImage: data['profileImage'] as String,
          email: credentials.user!.email ?? "",
          role: data['role'] as String
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

  Future<List<AppUser>> getAllUser() async {
    List<AppUser> users = List.empty(growable: true);
    QuerySnapshot<AppUser> userQuery = await _usersRef.get();

    for(DocumentSnapshot<AppUser> snapshot in userQuery.docs){

      if (snapshot.data() != null) {
        users.add(snapshot.data()!);
      }
    }

    return users;
  }

  Future<AppUser?> createNewUser(AppUser user, String tmpPassword) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);

    try {
      final credentials = await CreateUserRepository.createNewUser(user: user, tmpPassword: tmpPassword);
      AppUser newUser = user.copyWith(uid: credentials?.user?.uid);

      await _usersRef.doc(newUser.uid).set(newUser);
      return (await _usersRef.doc(newUser.uid).get()).data();

    } on Exception catch (e) {
      rethrow;
    }
  }

  updateUser(AppUser user) {
    //TODO implement updateUser
  }

}
