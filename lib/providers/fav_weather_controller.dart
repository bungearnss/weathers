import 'package:flutter/cupertino.dart';

import '../models/fav_weather.dart';
import '../models/current_weather.dart';
import '../services/db_helper.dart';
import '../services/weather_helper.dart';

class FavWeatherController with ChangeNotifier {
  List<FavoriteWeatherData> _items = [];
  List<FavoriteWeatherData> loadItem = [];
  CurrentWeather? pickedWeather;

  List<FavoriteWeatherData> get items {
    return [..._items];
  }

  Future<void> addFavoriteWeather(
    BuildContext context,
    FavoriteWeather favoriteWeather,
  ) async {
    weatherHelper(
      lat: favoriteWeather.location!.latitude.toString(),
      lon: favoriteWeather.location!.longitude.toString(),
    ).getCurrentWeather(onSuccess: (data) {
      pickedWeather = data;
      print('pickedWeather: $pickedWeather');

      String id = DateTime.now().toString();
      String _name;
      double _latitude;
      double _longtitude;
      double _temp;
      String _description;
      String _icon;
      String _iconPath;
      int _timezone;

      if (pickedWeather == null) {
        return;
      }

      String iconCondition(iconData) {
        late String condition;
        if (iconData != null) {
          switch (pickedWeather!.weather![0].icon!) {
            case '01n':
              condition = 'assets/images/clear_sky.png';
              break;
            case '02n':
            case '03n':
            case '04n':
              condition = 'assets/images/few_clouds.png';
              break;
            case '09n':
              condition = 'assets/images/shower_rain.png';
              break;
            case '10n':
              condition = 'assets/images/shower_rain.png';
              break;
            case '11n':
              condition = 'assets/images/thunderstorm.png';
              break;
            case '13n':
              condition = 'assets/images/snow.png';
              break;
            case '50n':
              condition = 'assets/images/mist.png';
              break;
            default:
              condition = 'assets/images/clear_sky.png';
          }
          return condition;
        }
        return 'assets/images/clear_sky.png';
      }

      _iconPath = iconCondition(pickedWeather!.weather![0].icon!);
      // print('_iconPath: $_iconPath');

      _name = pickedWeather!.name!;
      _latitude = pickedWeather!.coord!.lat!;
      _longtitude = pickedWeather!.coord!.lon!;
      _temp = pickedWeather!.main!.temp!;
      _description = pickedWeather!.weather![0].description!;
      // _icon = pickedWeather!.weather![0].icon!;
      _icon = _iconPath;
      _timezone = pickedWeather!.timezone!;

      final newFavWeather = FavoriteWeatherData(id, _name, _latitude,
          _longtitude, _temp, _description, _icon, _timezone);
      _items.add(newFavWeather);
      DBHelper.insert(
        'user_location',
        {
          'id': newFavWeather.id,
          'name': newFavWeather.name,
          'loc_lat': newFavWeather.latitude,
          'loc_lng': newFavWeather.longtitude,
          'temp': newFavWeather.temp,
          'description': newFavWeather.description,
          'icon': newFavWeather.icon,
          'timezone': newFavWeather.timezone,
        },
      );
      fetchAndSetFavoriteWeather();
    }, onError: (err) {
      print(err);
      notifyListeners();
    });
  }

  Future<void> deleteFavoriteWeather(String id) async {
    final existingFavoriteWeatherIndex =
        _items.indexWhere((item) => item.id == id);
    var existingFavoriteWeather = _items[existingFavoriteWeatherIndex];
    _items.removeAt(existingFavoriteWeatherIndex);
    notifyListeners();
    DBHelper.delete('user_location', id);
  }

  Future<void> fetchAndSetFavoriteWeather() async {
    final dataList = await DBHelper.getData('user_location');
    // print('dataList: $dataList');
    loadItem = dataList
        .map(
          (item) => FavoriteWeatherData(
            item['id'],
            item['name'],
            item['loc_lat'],
            item['loc_lng'],
            item['temp'],
            item['description'],
            item['icon'],
            item['timezone'],
          ),
        )
        .toList();
    _items = loadItem.reversed.toList();
    notifyListeners();
  }
}
