import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/Helper/network_helper.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitial()) {
    on<NetworkObserve>(_onNetworkObserve);
    on<NetworkNotify>(_onNetworkNotify);
  }
  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  FutureOr<void> _onNetworkObserve(NetworkObserve event, Emitter<NetworkState> emit) {
    NetworkHelper.observeNetwork();
  }

  FutureOr<void> _onNetworkNotify(NetworkNotify event, Emitter<NetworkState> emit) {
    event.isConnected ? emit(Connected()) : emit(Disconnected());
  }
}
