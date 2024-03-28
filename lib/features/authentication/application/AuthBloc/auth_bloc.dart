import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/user_repository.dart';
import '../../domain/Appuser.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(AuthInit()) {
    on<Authentication>(_onAuthentication);
    on<Logout>(_onLogout);
    on<ResetPassword>(_onResetPassword);

    userRepository.fireAuth.authStateChanges().listen((user) async {
      if(user != null){
        try {
         final userData = await userRepository.loadUserData(user.uid);

          AppUser u = AppUser(uid: user.uid,
            username: userData['username'] as String,
            profileImage: userData['profileImage'] as String,
            email:user.email ?? "",
            role: userData['role'] as String,
          );

          emit(Authenticated(user: u));
        } catch (e) {
          emit(LoggedOut());
        }
      }

      if(user == null){
        emit(LoggedOut());
      }
    });
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

  FutureOr<void> _onResetPassword(ResetPassword event, Emitter<AuthState> emit) {

    try {
      userRepository.resetPassword(event.email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
