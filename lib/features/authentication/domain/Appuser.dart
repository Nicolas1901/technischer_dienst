import 'package:firebase_auth/firebase_auth.dart';

class AppUser{

  final String uid;
  final String username;
  final String profileImage;
  final String email;

//<editor-fold desc="Data Methods">
  const AppUser({
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUser &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          profileImage == other.profileImage &&
          email == other.email);

  @override
  int get hashCode =>
      username.hashCode ^
      profileImage.hashCode ^
      email.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' username: $username,' +
        ' profileImage: $profileImage,' +
        ' email: $email,' +
        '}';
  }

  AppUser copyWith({
    String? uid,
    String? username,
    String? profileImage,
    String? email,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'username': this.username,
      'profileImage': this.profileImage,
      'email': this.email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      username: map['username'] as String,
      profileImage: map['profileImage'] as String,
      email: map['email'] as String,
    );
  }

//</editor-fold>
}