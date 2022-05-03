import 'package:dio/dio.dart';

class apiHelper {
  final String url;
  final Map<String, dynamic>? payloadData;

  apiHelper({
    required this.url,
    required this.payloadData,
  });

  final Dio _dio = Dio();

  void get({
    Function()? beforeSend,
    Function(dynamic data)? onSuccess,
    Function(dynamic err)? onError,
  }) {
    _dio.get(this.url, queryParameters: this.payloadData).then((res) {
      if (onSuccess != null) {
        onSuccess(res.data);
      }
    }).catchError((err) {
      if (onError != null) {
        onError(err);
      }
    });
  }
}
