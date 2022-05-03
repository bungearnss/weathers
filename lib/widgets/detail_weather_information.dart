import 'package:flutter/material.dart';

import '../models/current_weather.dart';
import '../services/temperature_unit_helper.dart';
import '../services/theme_setting.dart';

class DetailWeatherInformation extends StatefulWidget {
  CurrentWeather currentWeather;

  DetailWeatherInformation(this.currentWeather);

  @override
  _DetailWeatherInformationState createState() =>
      _DetailWeatherInformationState();
}

class _DetailWeatherInformationState extends State<DetailWeatherInformation> {
  static double boxWidth = 95;
  static double boxHight = 90;
  bool? isFahrenheit;
  bool? isDarkTheme;

  @override
  Widget build(BuildContext context) {
    var currentData = widget.currentWeather;

    double? _currentTempmin;
    double? _currentTempmax;
    double? _currentFeels;
    int? _currentPressure;
    int? _currentClouds;
    double? _currentWind;

    if (currentData != null) {
      _currentTempmin = currentData.main?.tempMin;
      _currentTempmax = currentData.main?.temp;
      _currentFeels = currentData.main?.feelsLike;
      _currentPressure = currentData.main?.pressure;
      _currentClouds = currentData.clouds?.all;
      _currentWind = currentData.wind?.speed;
    }

    isDarkTheme = ThemeSetting.instance.status;
    isFahrenheit = TemperatureUnitHelper.instance.isFahrenheit;

    return SizedBox(
      height: boxHight,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: boxWidth,
            height: boxHight,
            child: widget.currentWeather == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Card(
                    elevation: isDarkTheme == true ? 1 : 1.3,
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.device_thermostat,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          'MIN',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 12),
                        ),
                        Text(
                          _currentTempmin != null
                              ? isFahrenheit == true
                                  ? '${((_currentTempmin * 1.8) + 32).toStringAsFixed(2)}\u2109'
                                  : '${_currentTempmin.toStringAsFixed(2)}\u2103'
                              : '',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
          ),
          SizedBox(
            width: boxWidth,
            height: boxHight,
            child: Card(
              elevation: isDarkTheme == true ? 1 : 1.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wb_sunny_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'MAX',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    _currentTempmax != null
                        ? isFahrenheit == true
                            ? '${((_currentTempmax * 1.8) + 32).toStringAsFixed(2)}\u2109'
                            : '${_currentTempmax.toStringAsFixed(2)}\u2103'
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: boxWidth,
            height: boxHight,
            child: Card(
              elevation: isDarkTheme == true ? 1 : 1.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dry,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'FEEL LIKES',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    _currentFeels != null
                        ? isFahrenheit == true
                            ? '${((_currentFeels * 1.8) + 32).toStringAsFixed(2)}\u2109'
                            : '${(_currentFeels).toStringAsFixed(2)}\u2103'
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: boxWidth,
            height: boxHight,
            child: Card(
              elevation: isDarkTheme == true ? 1 : 1.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.format_color_reset_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'PRESSURE',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 13),
                  ),
                  Text(
                    _currentPressure != null ? '${(_currentPressure)} hPa' : '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: boxWidth,
            height: boxHight,
            child: Card(
              elevation: isDarkTheme == true ? 1 : 1.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'CLOUDS',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 13),
                  ),
                  Text(
                    _currentClouds != null ? '$_currentClouds %' : '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: boxWidth,
            height: boxHight,
            child: Card(
              elevation: isDarkTheme == true ? 1 : 1.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    'WIND',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 13),
                  ),
                  Text(
                    _currentWind != null ? '$_currentWind miles/h' : '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
