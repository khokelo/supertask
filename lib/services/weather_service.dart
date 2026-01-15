import 'dart:developer' as developer;
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _wf;

  WeatherService(String apiKey) : _wf = WeatherFactory(apiKey);

  Future<Weather> getCurrentWeather(double lat, double lon) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(lat, lon);
      return weather;
    } catch (e) {
      developer.log("Error getting weather: $e");
      rethrow;
    }
  }
}
