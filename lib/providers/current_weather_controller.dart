import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/current_weather.dart';
import '../services/weather_helper.dart';
import '../models/forcast_fiveday.dart';

class WeatherController with ChangeNotifier {
  CurrentWeather? currentWeather;
  List<FiveDay> fiveDayData = [];

  Future<void> getCurrentWeather(double latitude, double longtitude) async {
    weatherHelper(
      lat: latitude.toString(),
      lon: longtitude.toString(),
    ).getCurrentWeather(onSuccess: (data) async {
      currentWeather = data;
      print('currentWeather: $currentWeather');
      // notifyListeners();

      //setting up shared preferences
      final prefs = await SharedPreferences.getInstance();

      //this map which is converted to JSON which is a string
      String _name = data.name!;
      String _country = data.sys!.country!;
      String _icon = data.weather![0].icon!;
      String _temp = data.main!.temp.toString();
      String _description = data.weather![0].description!;
      String _tempMax = data.main!.tempMax.toString();
      String _tempMin = data.main!.tempMin.toString();
      String _feelsLike = data.main!.feelsLike.toString();
      String _pressure = data.main!.pressure.toString();
      String _cloud = data.clouds!.all.toString();
      String _wind = data.wind!.speed.toString();
      String _timezone = data.timezone.toString();

      final prefCurrentWeather = json.encode(
        {
          'name': _name,
          'country': _country,
          'icon': _icon,
          'temp': _temp,
          'description': _description,
          'tempMax': _tempMax,
          'tempMin': _tempMin,
          'feel': _feelsLike,
          'pressure': _pressure,
          'cloud': _cloud,
          'wind': _wind,
          'timezone': _timezone,
        },
      );
      prefs.setString('prefCurrentWeather', prefCurrentWeather);
      notifyListeners();
    }, onError: (err) async {
      print(err);
      notifyListeners();
    });
  }

  Future<void> getNextFivedayInformation(
    double latitude,
    double longtitude,
  ) async {
    weatherHelper(lat: latitude.toString(), lon: longtitude.toString())
        .getNextFiveDay(onSuccess: (data) async {
      fiveDayData = data;

      final prefs = await SharedPreferences.getInstance();

      final String encodeData = FiveDay.encode(data);
      await prefs.setString('prefFiveday', encodeData);
      notifyListeners();
    }, onError: (err) {
      print(err);
      notifyListeners();
    });
  }
}
