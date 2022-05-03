import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityController extends ChangeNotifier {
  // ConnectivityController() {
  //   Connectivity().onConnectivityChanged.listen((ConnectivityResult res) {
  //     resultHandler(res);
  //   });
  // }

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  String snackBarText =
      "Currently connected to no network. Please connect the internet to get current weather!";
  ConnectivityResult get connectivity => _connectivityResult;
  String get snackbarText => snackBarText;

  Future<void> resultHandler(ConnectivityResult result) async {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      snackBarText =
          'Currently connected to no network\nPlease connect the internet to get current information!';
    } else if (result == ConnectivityResult.mobile) {
      snackBarText = 'Currently connected to celluar network!';
    } else if (result == ConnectivityResult.wifi) {
      snackBarText = 'Currently connected to wifi!';
    }
    notifyListeners();
  }
}
