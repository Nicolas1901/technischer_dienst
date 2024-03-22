import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AppUser {
  final String uid;
  final String username;
  final String profileImage;
  final String email;
  final String role;

//<editor-fold desc="Data Methods">
  const AppUser({
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.email,
    required this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUser &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          profileImage == other.profileImage &&
          email == other.email &&
          role == other.role);

  @override
  int get hashCode =>
      username.hashCode ^
      profileImage.hashCode ^
      email.hashCode ^
      role.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' username: $username,' +
        ' profileImage: $profileImage,' +
        ' email: $email,' +
        ' role: $role,' +
        '}';
  }

  AppUser copyWith({
    String? uid,
    String? username,
    String? profileImage,
    String? email,
    String? role,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'username': this.username,
      'profileImage': this.profileImage,
      'email': this.email,
      'role': this.role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      username: map['username'] as String,
      profileImage: map['profileImage'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return AppUser(
        uid: snapshot.reference.id,
        username: data?['username'],
        profileImage: data?["profileImage"],
        email: data?["email"],
        role: data?["role"]);
  }

//</editor-fold>
}
