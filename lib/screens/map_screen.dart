import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import '../models/current_weather.dart';
import '../models/fav_weather.dart';
import '../providers/fav_weather_controller.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final bool isSelecting;

  MapScreen({
    required this.lat,
    required this.lng,
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isFavorite = false;
  bool _isSatellite = false;
  LatLng? _pickedLocation;
  late double lat;
  late double lng;
  late CurrentWeather getCurrentWeatherByLocation;
  TextEditingController controller = TextEditingController();
  GoogleMapController? mapController;
  LatLng? latLngprediction;
  String? placeName;

  @override
  bool get wantKeepAlive => true;

  void _selectLocation(LatLng position) {
    //store picked location
    setState(() {
      _pickedLocation = position;
      mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(_pickedLocation!, 12));
    });
  }

  LatLng _convertPosition(String latidude, String longitude) {
    // ignore: void_checks
    return LatLng(double.parse(latidude), double.parse(longitude));
  }

  Future<void> _onSelected() async {
    final selectLocation = FavoriteWeather(_pickedLocation, _isFavorite);
    Navigator.of(context).pop(selectLocation);

    if (_pickedLocation != null) {
      lat = _pickedLocation!.latitude;
      lng = _pickedLocation!.longitude;
    }

    if (_isFavorite == true) {
      print('_isFavorite: $_isFavorite');
      await Provider.of<FavWeatherController>(context, listen: false)
          .addFavoriteWeather(context, selectLocation);
    }
  }

  placesAutoCompleteTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.only(right: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      alignment: Alignment.center,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          textStyle: Theme.of(context).textTheme.bodyText1!,
          googleAPIKey: "AIzaSyA_qD6lhMIfvaVXtn6NO5J4e5wRHc2NxTA",
          inputDecoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                Icons.search,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            // ignore: unrelated_type_equality_checks
            suffixIcon: controller.text == "" || controller.clear == true
                ? null
                : IconButton(
                    icon: const Icon(Icons.highlight_off_rounded),
                    iconSize: 20,
                    color: Theme.of(context).primaryColor,
                    onPressed: controller.clear,
                  ),
            hintText: "Search your location",
            hintStyle: Theme.of(context).textTheme.bodyText1,
            border: InputBorder.none,
          ),
          debounceTime: 600,
          // countries: ["in", "fr"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {
            latLngprediction = _convertPosition(
                prediction.lat.toString(), prediction.lng.toString());
            _selectLocation(latLngprediction!);
          },
          itmClick: (prediction) {
            controller.text = prediction.description!;
            placeName = prediction.description!;
            FocusScope.of(context).requestFocus(FocusNode());
            controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: prediction.description!.length,
              ),
            );
          }),
    );
  }

  _setMapController(GoogleMapController controller) {
    mapController = controller;

    if (_pickedLocation != null) {
      mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(_pickedLocation!, 12));
    }
  }

  showConnectionResult() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite == true) {
      return Fluttertoast.showToast(
        msg: "Saved to your favorites.",
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black87,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
      );
    } else {
      return Fluttertoast.showToast(
        msg: "Romoved to your favorites",
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black87,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
      );
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Select location',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 20,
              ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          iconSize: 25,
          icon: const Icon(Icons.close),
          color: Theme.of(context).primaryColor,
          onPressed: Navigator.of(context).pop,
        ),
        actions: <Widget>[
          if (widget.isSelecting)
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: IconButton(
                    onPressed: () {
                      showConnectionResult();
                    },
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite
                          ? Colors.red[700]
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _pickedLocation == null ? null : _onSelected,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _isSatellite ? MapType.satellite : MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.lat,
                widget.lng,
              ),
              zoom: 16,
            ),
            onMapCreated: _setMapController,
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: (_pickedLocation == null)
                ? {
                    Marker(
                      markerId: const MarkerId('m1'),
                      position: LatLng(
                        widget.lat,
                        widget.lng,
                      ),
                      infoWindow: InfoWindow(
                        title:
                            placeName == null ? 'Your Location' : '$placeName',
                      ),
                    ),
                  }
                : {
                    Marker(
                      markerId: const MarkerId('m1'),
                      position: _pickedLocation ??
                          LatLng(
                            widget.lat,
                            widget.lng,
                          ),
                    ),
                  },
          ),
          Positioned(
            top: 0,
            child: placesAutoCompleteTextField(),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).backgroundColor,
              onPressed: () {
                setState(() {
                  _isSatellite = !_isSatellite;
                });
              },
              child: Icon(
                Icons.map_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
