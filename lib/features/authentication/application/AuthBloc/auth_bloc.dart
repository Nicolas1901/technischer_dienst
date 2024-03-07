import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/user_repository.dart';
import '../../domain/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  AuthBloc({required this.userRepository}) : super(AuthInitial()) {
    on<Authentication>(_onAuthentication);
  }

  FutureOr<void> _onAuthentication(Authentication event, Emitter<AuthState> emit) {
    final state = this.state;

    if(state is AuthInitial){

    }
  }
}
