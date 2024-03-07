import 'package:pocketbase/pocketbase.dart';

class User{

  final String username;
  final String profileImage;
  final String email;
  final AuthStore authStore;

//<editor-fold desc="Data Methods">
  const User({
    required this.username,
    required this.profileImage,
    required this.email,
    required this.authStore,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          profileImage == other.profileImage &&
          email == other.email &&
          authStore == other.authStore);

  @override
  int get hashCode =>
      username.hashCode ^
      profileImage.hashCode ^
      email.hashCode ^
      authStore.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' username: $username,' +
        ' profileImage: $profileImage,' +
        ' email: $email,' +
        ' authStore: $authStore,' +
        '}';
  }

  User copyWith({
    String? username,
    String? profileImage,
    String? email,
    AuthStore? authStore,
  }) {
    return User(
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      authStore: authStore ?? this.authStore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'profileImage': this.profileImage,
      'email': this.email,
      'authStore': this.authStore,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      profileImage: map['profileImage'] as String,
      email: map['email'] as String,
      authStore: map['authStore'] as AuthStore,
    );
  }

//</editor-fold>
}