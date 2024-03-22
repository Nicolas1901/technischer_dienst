part of 'manage_users_bloc.dart';

abstract class ManageUsersState extends Equatable {
  const ManageUsersState();
}

class ManageUsersInitial extends ManageUsersState {
  @override
  List<Object> get props => [];
}

class UsersLoaded extends ManageUsersState{
  final List<AppUser> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class LoadingFailed extends ManageUsersState{
  final String message;

  const LoadingFailed({required this.message});

  @override
  List<Object> get props => [];
}