import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/current_weather.dart';
import '../services/api_helper.dart';
import '../models/forcast_fiveday.dart';

class weatherHelper {
  // final String city;
  final String lat;
  final String lon;

  String baseUrl = 'http://api.openweathermap.org/data/2.5';
  String apiKey = 'aa256c7d9bcb8cda33d46ed08915d5fd';

  weatherHelper({
    required this.lat,
    required this.lon,
  });

  void getCurrentWeather({
    Function()? beforeSend,
    Function(CurrentWeather currentWeather)? onSuccess,
    Function(dynamic err)? onError,
  }) {
    final url =
        '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&lang=en&units=metric';
    apiHelper(url: url, payloadData: null).get(
        beforeSend: () => {
              if (beforeSend != null)
                {
                  beforeSend(),
                }
            },
        onSuccess: (data) => {
              onSuccess!(CurrentWeather.fromJson(data)),
            },
        onError: (err) => {
              if (onError != null)
                {
                  print(err),
                  onError(err),
                }
            });
  }

  void getNextFiveDay({
    Function()? beforeSend,
    Function(List<FiveDay> fiveDatData)? onSuccess,
    Function(dynamic err)? onError,
  }) {
    final url =
        '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&lang=en&units=metric';
    apiHelper(url: url, payloadData: null).get(
        beforeSend: () => {},
        onSuccess: (data) => {
              // print(data),
              onSuccess!((data['list'] as List)
                  .map((item) => FiveDay.fromJson(item))
                  .toList()),
            },
        onError: (error) => {
              print(error),
              onError!(error),
            });
  }
}
