import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/services/weather_service.dart';
import 'package:weather/weather.dart';
import 'dart:developer' as developer;

class LocationController with ChangeNotifier {
  Position? _currentPosition;
  Weather? _weather;
  bool _loading = false;
  String? _error;

  Position? get currentPosition => _currentPosition;
  Weather? get weather => _weather;
  bool get loading => _loading;
  String? get error => _error;

  final WeatherService _weatherService = WeatherService("4223f2115e0c8b35b639e14de7131175");

  Future<void> getCurrentLocationAndWeather() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPosition = await _determinePosition();
      if (_currentPosition != null) {
        _weather = await _weatherService.getCurrentWeather(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } catch (e) {
      _error = e.toString();
      developer.log("Error in location_controller: $_error");
    }

    _loading = false;
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
