import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../models/theme.dart';
import '../providers/fav_weather_controller.dart';
import '../providers/current_weather_controller.dart';

import '../services/temperature_unit_helper.dart';
import '../services/theme_setting.dart';

class FavoriteWeatherItem extends StatelessWidget {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final double temp;
  final String description;
  final String icon;
  final int timezone;

  FavoriteWeatherItem(
    this.id,
    this.name,
    this.lat,
    this.lon,
    this.temp,
    this.description,
    this.icon,
    this.timezone,
  );

  @override
  Widget build(BuildContext context) {
    var enableDarkTheme = false;
    var enableF = false;
    String? currentTime;
    String? currentDate;

    enableDarkTheme = ThemeSetting.instance.status;
    enableF = TemperatureUnitHelper.instance.isFahrenheit;
    final scaffold = Scaffold.of(context);

    String convertTime = DateTime.now()
        .add(Duration(
            seconds: timezone - DateTime.now().timeZoneOffset.inSeconds))
        .toString();
    var parts = convertTime.split(RegExp(r"[:,-,' ',.]"));
    var date = parts[0].trim();
    var time =
        '${parts[1].trim()}:${parts[2].trim()}:${parts[3].trim()}:${parts[4].trim()}';

    var dateFormat = DateFormat().add_MMMMEEEEd().format(DateTime.parse(date));
    var timeFormat =
        DateFormat().add_jm().format(DateFormat('hh:mm:ss').parse(time));
    currentTime = timeFormat;
    currentDate = dateFormat;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<WeatherController>(context, listen: false)
            .getCurrentWeather(
          lat,
          lon,
        );

        Provider.of<WeatherController>(context, listen: false)
            .getNextFivedayInformation(
          lat,
          lon,
        );
      },
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 35,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                'Are you sure to delete ?',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 22),
              ),
              content: Text(
                'Do you want to remove this location',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('No'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Yes'),
                )
              ],
            ),
          );
        },
        onDismissed: (direction) async {
          // Provider.of<FavWeatherController>(context, listen: false)
          //     .deleteFavoriteWeather(id);
          try {
            await Provider.of<FavWeatherController>(context, listen: false)
                .deleteFavoriteWeather(id);
          } catch (err) {
            scaffold.showSnackBar(
              SnackBar(
                content: const Text(
                  'Deleting failed!, Please try again',
                  textAlign: TextAlign.right,
                ),
                backgroundColor: Colors.grey[700],
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Card(
          color: enableDarkTheme ? darkTheme.cardColor : lightTheme.cardColor,
          elevation: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(icon),
                ),
              ),
              title: Text(
                name,
                style:
                    // Theme.of(context).textTheme.headline6!.copyWith(fontSize: 20),
                    enableDarkTheme
                        ? darkTheme.textTheme.headline6!.copyWith(fontSize: 20)
                        : lightTheme.textTheme.headline6!
                            .copyWith(fontSize: 20),
              ),
              subtitle: Text(
                '$currentTime\n$currentDate',
                style:
                    // Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                    enableDarkTheme
                        ? darkTheme.textTheme.bodyText1!.copyWith(fontSize: 12)
                        : lightTheme.textTheme.bodyText1!
                            .copyWith(fontSize: 12),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  // ignore: unnecessary_null_comparison
                  temp != null
                      ? enableF
                          ? '${((temp * 1.8) + 32).toStringAsFixed(1)} \u2109'
                          : '${temp.toStringAsFixed(1)} \u2103'
                      : '',
                  style:
                      // Theme.of(context).textTheme.headline6!.copyWith(fontSize: 22),
                      enableDarkTheme
                          ? darkTheme.textTheme.headline6!
                              .copyWith(fontSize: 22)
                          : lightTheme.textTheme.headline6!
                              .copyWith(fontSize: 22),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
