import 'dart:convert';

import '../models/coord.dart';
import '../models/weather.dart';
import '../models/main_weather.dart';
import '../models/wind.dart';
import '../models/clouds.dart';
import '../models/sys.dart';

class CurrentWeather {
  final Coord? coord;
  final List<Weather>? weather;
  final String? base;
  final MainWeather? main;
  final int? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  CurrentWeather({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  factory CurrentWeather.fromJson(dynamic json) {
    if (json == null) {
      return CurrentWeather();
    }

    return CurrentWeather(
      coord: Coord.fromJson(json['coord']),
      weather: (json['weather'] as List)
          .map((weather) => Weather.fromJson(weather))
          .toList(),
      base: json['base'],
      main: MainWeather.fromJson(json['main']),
      visibility: json['visibility'],
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }
}
