import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:technischer_dienst/features/authentication/application/AuthBloc/MockAuthEvents.dart';

import '../../data/user_repository.dart';
import '../../domain/user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(LoggedOut()) {
    on<Authentication>(_onAuthentication);
    on<Logout>(_onLogout);
    on<MockAuthentication>(_onMockAuthentication);
  }

  FutureOr<void> _onAuthentication(
      Authentication event, Emitter<AuthState> emit) async {

    final User user = await userRepository.authenticateUser(
        usernameOrEmail: event.usernameOrEmail, password: event.password);

    if (user.authStore.isValid) {
      emit(Authenticated(user: user));
    } else {
      emit(LoginFailed());
    }
  }

  FutureOr<void> _onLogout(Logout event, Emitter<AuthState> emit) {
    userRepository.logoutUser();
    emit(LoggedOut());
  }

  FutureOr<void> _onMockAuthentication(MockAuthentication event, Emitter<AuthState> emit) {
    //emit(LoginFailed());
    emit(Authenticated(user: event.user));
  }
}
