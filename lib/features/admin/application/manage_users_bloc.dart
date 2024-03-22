import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../authentication/data/user_repository.dart';
import '../../authentication/domain/Appuser.dart';

part 'manage_users_event.dart';
part 'manage_users_state.dart';

class ManageUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserRepository userRepository;

  ManageUsersBloc({required this.userRepository}) : super(ManageUsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<CreateUserEvent>(_onCreateUser);
  }

  FutureOr<void> _onLoadUsers(LoadUsers event, Emitter<ManageUsersState> emit) async {

    try {
       List<AppUser> users = await  userRepository.getAllUser();

       emit(UsersLoaded(users: users));
     } on Exception catch (e) {
       emit(LoadingFailed(message: e.toString()));
     }
  }

  FutureOr<void> _onCreateUser(CreateUserEvent event, Emitter<ManageUsersState> emit) async {
    final state = this.state;

    if(state is UsersLoaded){
      try {
        AppUser? newUser = await userRepository.createNewUser(event.user,event.password);

        if(newUser != null) {
          final List<AppUser> users = state.users;
          users.add(newUser);
          emit(UsersLoaded(users: users));
        }
      } on Exception catch (e) {
        debugPrint("creationFailed");
      }
    }
  }
}
