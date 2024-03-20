part of 'connection_bloc.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();
}

class NetworkInitial extends NetworkState {
  @override
  List<Object> get props => [];
}

class Connected extends NetworkState{
  @override
  List<Object> get props => [];
}

class Disconnected extends NetworkState{
  @override
  List<Object> get props => [];
}
