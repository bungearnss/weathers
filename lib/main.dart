import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import './providers/current_weather_controller.dart';
import './providers/fav_weather_controller.dart';
import './providers/network_controller.dart';

import './services/theme_setting.dart';

import './models/theme.dart';

import './screens/home_screen.dart';
import './screens/favorite_wather_screen.dart';

void main() {
  runApp(const MyApp());
}

enum FilterOptions {
  Theme,
  Temp,
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var enableDarkTheme = false;
  // var enableF = false;
  late double currentLat;
  late double currentLon;
  LatLng? lat;
  LatLng? lng;

  @override
  Widget build(BuildContext context) {
    enableDarkTheme = ThemeSetting.instance.status;
    // TemperatureUnitHelper.instance.setStatus(enableF);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: WeatherController(),
        ),
        ChangeNotifierProvider.value(
          value: FavWeatherController(),
        ),
        ChangeNotifierProvider.value(
          value: ConnectivityController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: enableDarkTheme ? darkTheme : lightTheme,
        home: SafeArea(
          child: homeScreen(),
        ),
        routes: {
          FavoriteWeatherScreen.routeName: (ctx) => FavoriteWeatherScreen(),
        },
      ),
    );
  }
}
