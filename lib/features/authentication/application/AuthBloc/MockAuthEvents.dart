import 'package:firebase_auth/firebase_auth.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:technischer_dienst/features/authentication/application/AuthBloc/auth_bloc.dart';
import 'package:technischer_dienst/features/authentication/domain/Appuser.dart';

class MockAuthentication extends AuthEvent {
  final AppUser user = const AppUser(
    username: "Nicolas",
    profileImage: "",
    email: "nicolas.will01@gmail.com",
    uid: 'skdjhswre99t0ret9',
  );

  @override
  List<Object> get props => [];
}
