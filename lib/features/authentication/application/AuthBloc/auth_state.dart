part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class LoggedOut extends AuthState {
  //TODO Set user Object from Shared preferences if possible
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final AppUser user;

  const Authenticated({required this.user});

  @override
  List<Object> get props => [];
}

class LoginFailed extends AuthState{
  final String message;

  const LoginFailed({required this.message});

  @override
  List<Object> get props => [];
}