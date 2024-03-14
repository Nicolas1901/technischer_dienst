import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:technischer_dienst/features/authentication/application/AuthBloc/MockAuthEvents.dart';

import '../../data/user_repository.dart';
import '../../domain/Appuser.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(LoggedOut()) {
    on<Authentication>(_onAuthentication);
    on<Logout>(_onLogout);
  }

  FutureOr<void> _onAuthentication(
      Authentication event, Emitter<AuthState> emit) async {
    try {
      final AppUser user =
          await userRepository.signIn(event.usernameOrEmail, event.password);
      emit(Authenticated(user: user));

    } on FirebaseAuthException catch (e) {
      emit(LoginFailed(message: e.message ?? "Etwas ist schiefgelaufen"));
    }

  }

  FutureOr<void> _onLogout(Logout event, Emitter<AuthState> emit) {
    userRepository.signOut();
    emit(LoggedOut());
  }
}
