import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:technischer_dienst/shared/application/connection_bloc/connection_bloc.dart';

class NetworkHelper{

  static void observeNetwork(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
        debugPrint("disconnected");
        NetworkBloc().add(NetworkNotify());
      }
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        debugPrint("connected");
        NetworkBloc().add(NetworkNotify(isConnected: true));
      }
    });
  }
}