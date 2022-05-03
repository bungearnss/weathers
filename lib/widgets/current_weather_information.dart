import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';
import 'package:weathers_app/models/current_weather.dart';

import '../services/temperature_unit_helper.dart';

class CurrentWeatherInformation extends StatefulWidget {
  CurrentWeather currentWeather;

  CurrentWeatherInformation(this.currentWeather);

  @override
  State<CurrentWeatherInformation> createState() =>
      _CurrentWeatherInformationState();
}

class _CurrentWeatherInformationState extends State<CurrentWeatherInformation> {
  LatLng? lat;
  LatLng? lng;
  bool? isFahrenheit;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var currentData = widget.currentWeather;
    print('currentData: $currentData');
    String? _currentName;
    String? _currentSys;
    String? _currentIcon;
    double? _currentTemp;
    String? _currentDescription;
    int? _currentTimezone;
    String? currentTime;
    String? currentDate;
    double imageWidth = 120;
    double imageHeight = 90;

    _currentName = currentData.name;
    _currentSys = currentData.sys?.country;
    _currentIcon = currentData.weather?[0].icon;
    _currentTemp = currentData.main?.temp;
    _currentDescription = currentData.weather?[0].description;
    _currentTimezone = currentData.timezone;

    if (_currentTimezone != null) {
      String convertTime = DateTime.now()
          .add(Duration(
              seconds:
                  _currentTimezone - DateTime.now().timeZoneOffset.inSeconds))
          .toString();
      var parts = convertTime.split(RegExp(r"[:,-,' ',.]"));
      var date = parts[0].trim();
      var time =
          '${parts[1].trim()}:${parts[2].trim()}:${parts[3].trim()}:${parts[4].trim()}';

      var dateFormat =
          DateFormat().add_MMMMEEEEd().format(DateTime.parse(date));
      var timeFormat =
          DateFormat().add_jm().format(DateFormat('hh:mm:ss').parse(time));
      currentTime = timeFormat;
      currentDate = dateFormat;
    }

    String iconCondition(iconData) {
      late String condition;
      if (iconData != null) {
        switch (_currentIcon) {
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

    isFahrenheit = TemperatureUnitHelper.instance.isFahrenheit;

    return OverflowBox(
      minWidth: 0.0,
      maxWidth: width,
      minHeight: 0.0,
      maxHeight: height / 2.8,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            width: double.infinity,
            height: double.infinity,
            // color: Colors.amber,
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              // color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: Text(
                      (_currentName != null || _currentSys != null)
                          ? '$_currentName, $_currentSys '
                          : '',
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 28),
                    ),
                  ),
                  Text(
                    currentDate ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 13),
                  ),
                  Text(
                    currentTime ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 13),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        (_currentIcon == null && _currentTemp == null)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 5),
                                      // color: Colors.yellow,
                                      child: Image.asset(
                                        iconCondition(_currentIcon),
                                        height: imageHeight,
                                        width: imageWidth,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      )),
                                  Container(
                                    width: width * 0.47,
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 10),
                                    child: Text(
                                      _currentTemp != null
                                          ? isFahrenheit == true
                                              ? '${((_currentTemp * 1.8) + 32).toStringAsFixed(0)}\u2109'
                                              : '${_currentTemp.toStringAsFixed(0)}\u2103'
                                          : '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            fontSize: 70,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                        Text(
                          _currentDescription ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
