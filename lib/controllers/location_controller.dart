import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:myapp/services/weather_service.dart';

class LocationController with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  Position? _currentPosition;
  Weather? _currentWeather;
  bool _isLoading = false;

  Position? get currentPosition => _currentPosition;
  Weather? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;

  Future<void> getCurrentLocationAndWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentPosition = await _determinePosition();
      if (_currentPosition != null) {
        _currentWeather = await _weatherService.getCurrentWeather(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi dinonaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
