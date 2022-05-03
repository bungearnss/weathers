import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/temperature_unit_helper.dart';
import '../services/theme_setting.dart';

import '../models/theme.dart';

import '../providers/fav_weather_controller.dart';

import '../widgets/favorite_weather_item.dart';

class FavoriteWeatherScreen extends StatefulWidget {
  static const routeName = '/favorite_screen';

  @override
  State<FavoriteWeatherScreen> createState() => _FavoriteWeatherScreenState();
}

class _FavoriteWeatherScreenState extends State<FavoriteWeatherScreen> {
  var enableDarkTheme = false;
  var enableF = false;
  Future? _favoriteItemsFuture;

  Future _obtainfavoriteItemsFuture() {
    return Provider.of<FavWeatherController>(context, listen: false)
        .fetchAndSetFavoriteWeather();
  }

  @override
  void initState() {
    _favoriteItemsFuture = _obtainfavoriteItemsFuture();
    //getting out future and storing it in a property then this widget is create
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    enableDarkTheme = ThemeSetting.instance.status;
    enableF = TemperatureUnitHelper.instance.isFahrenheit;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: enableDarkTheme
            ? darkTheme.backgroundColor
            : lightTheme.backgroundColor,
        elevation: 2,
        title: Text(
          'Saved Location',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 20,
                color: enableDarkTheme
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
              ),
        ),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: enableDarkTheme
                ? darkTheme.primaryColor
                : lightTheme.primaryColor,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _favoriteItemsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text(
                  'An err occurred! Please try to refresh.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            } else {
              return Consumer<FavWeatherController>(
                child: Center(
                  child: Text(
                    'Got no favorite location, start adding some!',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                builder: (ctx, favWeather, ch) => favWeather.items.isEmpty
                    ? ch!
                    : Container(
                        color: enableDarkTheme
                            ? darkTheme.backgroundColor
                            : lightTheme.backgroundColor,
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => FavoriteWeatherItem(
                            favWeather.items[index].id,
                            favWeather.items[index].name,
                            favWeather.items[index].latitude,
                            favWeather.items[index].longtitude,
                            favWeather.items[index].temp,
                            favWeather.items[index].description,
                            favWeather.items[index].icon,
                            favWeather.items[index].timezone,
                          ),
                          itemCount: favWeather.items.length,
                        ),
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
