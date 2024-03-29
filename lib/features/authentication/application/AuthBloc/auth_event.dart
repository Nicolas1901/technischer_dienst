part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class Authentication extends AuthEvent{
  final String password;
  final String usernameOrEmail;

  Authentication({required this.password, required this.usernameOrEmail});

  @override
  List<Object> get props => [password, usernameOrEmail];
}

class ResetPassword extends AuthEvent{
  final String email;

  const ResetPassword({required this.email});
  @override
  List<Object> get props => [];
}

class Logout extends AuthEvent {
  @override
  List<Object> get props => [];
}