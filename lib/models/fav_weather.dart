import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoriteWeather {
  final LatLng? location;
  final bool isFavorite;

  FavoriteWeather(this.location, this.isFavorite);
}

class FavoriteWeatherData {
  late String id;
  late String name;
  late double latitude;
  late double longtitude;
  late double temp;
  late String description;
  late String icon;
  late int timezone;

  FavoriteWeatherData(
    this.id,
    this.name,
    this.latitude,
    this.longtitude,
    this.temp,
    this.description,
    this.icon,
    this.timezone,
  );
}
