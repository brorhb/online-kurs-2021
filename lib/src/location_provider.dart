import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:rxdart/subjects.dart";

class LocationProvider with ChangeNotifier {
  final BehaviorSubject<Position> _locationStream = BehaviorSubject();
  Stream<Position> get locationStream => _locationStream.stream;
  set _setLocation(Position val) {
    _locationStream.sink.add(val);
  }

  LocationProvider() {
    init();
  }

  Future<void> init() async {
    bool permission = await getPermission();
    if (permission) {
      Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).listen(
        (event) {
          _setLocation = event;
        },
      );
    }
  }

  Future<bool> getPermission() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      locationPermission = await Geolocator.requestPermission();
    }

    return locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse;
  }

  @override
  void dispose() {
    _locationStream.drain();
    super.dispose();
  }
}
