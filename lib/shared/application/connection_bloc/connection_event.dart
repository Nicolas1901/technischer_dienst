part of 'connection_bloc.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();
}

class NetworkObserve extends NetworkEvent{
  @override
  List<Object> get props => [];
}

class NetworkNotify extends NetworkEvent{
  final bool isConnected;

  NetworkNotify({this.isConnected = false});

  @override
  List<Object> get props => [];
}
