import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:technischer_dienst/shared/application/connection_bloc/connection_bloc.dart';

class NetworkHelper{

  static void observeNetwork(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
        NetworkBloc().add(NetworkNotify());
      }
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        NetworkBloc().add(NetworkNotify(isConnected: true));
      }
    });
  }
}