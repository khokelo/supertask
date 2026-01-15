import 'dart:developer' as developer;
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _wf = WeatherFactory("YOUR_API_KEY");

  Future<Weather> getWeather(double lat, double lon) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(lat, lon);
      return weather;
    } catch (e) {
      developer.log("Error getting weather: $e");
      rethrow;
    }
  }
}
