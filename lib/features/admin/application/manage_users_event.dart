part of 'manage_users_bloc.dart';

abstract class ManageUsersEvent extends Equatable {
  const ManageUsersEvent();
}

class LoadUsers extends ManageUsersEvent{
  @override
  List<Object> get props => [];
}

class CreateUserEvent extends ManageUsersEvent{
  final AppUser user;
  final String password;

  CreateUserEvent({required this.password,required this.user});

  @override
  List<Object> get props => [user];
}