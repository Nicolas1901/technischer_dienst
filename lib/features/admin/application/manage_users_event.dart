part of 'manage_users_bloc.dart';

abstract class ManageUsersEvent extends Equatable {
  const ManageUsersEvent();
}

class LoadUsers extends ManageUsersEvent{
  @override
  List<Object> get props => [];
}
