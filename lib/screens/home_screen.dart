import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/theme.dart';
import '../models/fav_weather.dart';
import '../models/current_weather.dart';
import '../models/sys.dart';
import '../models/weather.dart';
import '../models/main_weather.dart';
import '../models/clouds.dart';
import '../models/wind.dart';
import '../models/forcast_fiveday.dart';

import '../services/theme_setting.dart';
import '../services/temperature_unit_helper.dart';
import '../services/network_helper.dart';

import '../providers/current_weather_controller.dart';
import '../providers/network_controller.dart';

import '../screens/map_screen.dart';
import '../screens/favorite_wather_screen.dart';
import '../widgets/forcast_next_fiveday.dart';
import '../widgets/current_weather_information.dart';
import '../widgets/detail_weather_information.dart';

import '../models/http_exception.dart';

enum FilterOptions {
  Theme,
  Temp,
}

class homeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  double? currentLat;
  double? currentLon;
  var enableDarkTheme = false;
  var enableF = false;
  Position? currentPosition;
  Location location = Location();
  var connectionStatus;
  var subscription;
  // ignore: unnecessary_question_mark
  dynamic extractedPrefCurrentWeather;
  dynamic extractedPrefFiveDay;
  String? snackbarText;
  CurrentWeather? sharedPefWeather;
  late CurrentWeather prefWeather;
  List<FiveDay>? sharedfiveDay = [];
  String? fivedayString;

  Future<geolocator.Position> getCurrentLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.best,
      forceAndroidLocationManager: true,
    ).catchError((e) async {
      throw HttpException('$e');
    });
    return position;
  }

  Future<ConnectivityResult> initConnectivityStatus() async {
    ConnectivityResult connectivityStatus = ConnectivityResult.none;
    connectivityStatus = await (Connectivity().checkConnectivity());
    return connectivityStatus;
  }

  showConnectionResult() {
    if (connectionStatus == ConnectivityResult.none) {
      return Fluttertoast.showToast(
        msg: snackbarText!,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 2,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //check network if result == wifi or cellular then get current Weather by location
    //else use data is in Sharedpreferences
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      setState(() => connectionStatus = result);
    });

    initConnectivityStatus().then(
      (status) async {
        print('status: $status');
        setState(() => connectionStatus = status);
        NetworkHelper.instance.setNetworkStatus(status);
        Provider.of<ConnectivityController>(context, listen: false)
            .resultHandler(status);
        snackbarText =
            Provider.of<ConnectivityController>(context, listen: false)
                .snackBarText;
        // print('connectionResult: $snackbarText');

        if (status == ConnectivityResult.none) {
          await getSharedPref();
        }

        getCurrentLocation().then(
          (position) {
            Provider.of<WeatherController>(context, listen: false)
                .getCurrentWeather(
              position.latitude,
              position.longitude,
            );
            currentLat = position.latitude;
            currentLon = position.longitude;

            Provider.of<WeatherController>(context, listen: false)
                .getNextFivedayInformation(
              position.latitude,
              position.longitude,
            );
          },
        );
        showConnectionResult();
      },
    );
  }

  Future<void> getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('prefCurrentWeather') == null ||
        prefs.getString('prefFiveday') == null) {
      return;
    }

    extractedPrefCurrentWeather =
        json.decode(prefs.getString('prefCurrentWeather')!);

    final jsonWeather = [
      {
        'description': extractedPrefCurrentWeather['description'],
        'icon': extractedPrefCurrentWeather['icon'],
      }
    ];

    sharedPefWeather = CurrentWeather(
      name: extractedPrefCurrentWeather['name'],
      sys: Sys(country: extractedPrefCurrentWeather['country']),
      weather:
          (jsonWeather).map((weather) => Weather.fromJson(weather)).toList(),
      main: MainWeather(
        temp: double.parse(extractedPrefCurrentWeather['temp']),
        feelsLike: double.parse(extractedPrefCurrentWeather['feel']),
        tempMax: double.parse(extractedPrefCurrentWeather['tempMax']),
        tempMin: double.parse(extractedPrefCurrentWeather['tempMin']),
        pressure: int.parse(extractedPrefCurrentWeather['pressure']),
      ),
      timezone: int.parse(extractedPrefCurrentWeather['timezone']),
      clouds: Clouds(all: int.parse(extractedPrefCurrentWeather['cloud'])),
      wind: Wind(speed: double.parse(extractedPrefCurrentWeather['wind'])),
    );

    if (sharedPefWeather != null) {
      prefWeather = sharedPefWeather!;
    }

    final String fivedayString = prefs.getString('prefFiveday')!;

    final fivedays = (json.decode(fivedayString) as List<dynamic>)
        .map<FiveDay>((e) => FiveDay(
              date: e['date'],
              tempC: e['tempC'],
              tempF: e['tempF'],
            ))
        .toList();
    // print('fivedays: $fivedays');

    sharedfiveDay = fivedays;
  }

  Future<void> openMap() async {
    //when we push once that screen is popped, we can return data with pop and then listen to
    final selectedLocation = await Navigator.of(context).push<FavoriteWeather>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          lat: currentLat!,
          lng: currentLon!,
          isSelecting: true,
        ),
      ),
    );

    /* old code */
    if (selectedLocation == null) {
      return;
    }

    //return current data SO use then to provide this data
    Provider.of<WeatherController>(context, listen: false).getCurrentWeather(
      selectedLocation.location!.latitude,
      selectedLocation.location!.longitude,
    );

    Provider.of<WeatherController>(context, listen: false)
        .getNextFivedayInformation(
      selectedLocation.location!.latitude,
      selectedLocation.location!.longitude,
    );
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> openFavoriteList() async {
    Navigator.of(context).pushNamed(FavoriteWeatherScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    ThemeSetting.instance.setStatus(enableDarkTheme);
    TemperatureUnitHelper.instance.setStatus(enableF);
    getSharedPref();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: enableDarkTheme ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: enableDarkTheme
              ? darkTheme.backgroundColor
              : lightTheme.backgroundColor,
          elevation: 0,
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.Theme) {
                    enableDarkTheme = !enableDarkTheme;
                  } else {
                    enableF = !enableF;
                  }
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enable Dark Theme",
                          style: Theme.of(context).textTheme.bodyText1),
                      Icon(
                        enableDarkTheme ? Icons.check : null,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  value: FilterOptions.Theme,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enable ℉",
                          style: Theme.of(context).textTheme.bodyText1),
                      Icon(
                        enableF ? Icons.check : null,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  value: FilterOptions.Temp,
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 10),
                      iconSize: 28,
                      icon: const Icon(Icons.format_list_bulleted_rounded),
                      color: enableDarkTheme
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      onPressed: openFavoriteList,
                    ),
                    Icon(
                      Icons.settings,
                      color: enableDarkTheme
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: enableDarkTheme
            ? darkTheme.backgroundColor
            : lightTheme.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: Consumer<WeatherController>(
          builder: (
            ctx,
            controller,
            ch,
          ) =>
              Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Positioned(
                      right: 30,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.only(top: 5),
                        // color: Colors.amber,
                        child: IconButton(
                          alignment: Alignment.centerRight,
                          icon: Icon(
                            Icons.add_location_rounded,
                            color: enableDarkTheme
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                            size: 35,
                          ),
                          onPressed: openMap,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.2),
                      child: SizedBox(
                        width: NetworkHelper.instance.status ==
                                ConnectivityResult.none
                            ? MediaQuery.of(context).size.width
                            : 10,
                        height: NetworkHelper.instance.status ==
                                ConnectivityResult.none
                            ? MediaQuery.of(context).size.height * 0.19
                            : 10,
                        child: NetworkHelper.instance.status ==
                                ConnectivityResult.none
                            ? sharedPefWeather == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Can't get data\nPlease connect to internet before use.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                color: enableDarkTheme
                                                    ? Colors.white
                                                    : Colors.blueGrey[700],
                                                fontSize: 22,
                                              ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 8.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget,
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'Retry',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : CurrentWeatherInformation(
                                    prefWeather,
                                  )
                            : controller.currentWeather == null
                                ? sharedPefWeather == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CurrentWeatherInformation(
                                        sharedPefWeather!,
                                      )
                                : CurrentWeatherInformation(
                                    controller.currentWeather!,
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.only(top: 45),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 5),
                                child: Text(
                                  'other information'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 15,
                                        color: enableDarkTheme
                                            ? Colors.white
                                            : null,
                                      ),
                                ),
                              ),
                              NetworkHelper.instance.status ==
                                      ConnectivityResult.none
                                  ? sharedPefWeather == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DetailWeatherInformation(
                                          sharedPefWeather!,
                                        )
                                  : controller.currentWeather == null
                                      ? sharedPefWeather == null
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : DetailWeatherInformation(
                                              sharedPefWeather!,
                                            )
                                      : DetailWeatherInformation(
                                          controller.currentWeather!,
                                        ),
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                        top: 10,
                                      ),
                                      child: Text(
                                        'forcast next 5 days'.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              fontSize: 15,
                                              color: enableDarkTheme
                                                  ? Colors.white
                                                  : null,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              NetworkHelper.instance.status ==
                                      ConnectivityResult.none
                                  ? sharedfiveDay == []
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        )
                                      : ForcastNextFiveday(sharedfiveDay!)
                                  : controller.fiveDayData == []
                                      ? sharedfiveDay == []
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )
                                          : ForcastNextFiveday(
                                              controller.fiveDayData,
                                            )
                                      : ForcastNextFiveday(
                                          sharedfiveDay!,
                                        ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
