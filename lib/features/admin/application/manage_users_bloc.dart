import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../authentication/data/user_repository.dart';
import '../../authentication/domain/Appuser.dart';

part 'manage_users_event.dart';
part 'manage_users_state.dart';

class ManageUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserRepository userRepository;

  ManageUsersBloc({required this.userRepository}) : super(ManageUsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
  }

  FutureOr<void> _onLoadUsers(LoadUsers event, Emitter<ManageUsersState> emit) async {
    emit(UsersLoaded(users: [
      const AppUser(uid: "",
          username: "Nico",
          profileImage: "",
          email: "Nicolas.will01@gmail.com")
    ]));

    /*try {
       List<AppUser> users = await  userRepository.getAllUser();

       emit(UsersLoaded(users: users));
     } on Exception catch (e) {
       emit(LoadingFailed(message: e.toString()));
     }*/
  }
}
