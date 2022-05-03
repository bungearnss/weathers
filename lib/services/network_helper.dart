import 'package:connectivity/connectivity.dart';

class NetworkHelper {
  ConnectivityResult? status;

  NetworkHelper(this.status);
  NetworkHelper._myConstructor();
  static NetworkHelper instance = NetworkHelper._myConstructor();

  void setNetworkStatus(data) {
    status = data;
    // print('setNetworkStatus: $status');
  }
}
