import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _wf = WeatherFactory('180d3346877967907ef88471d0d7a329'); // Ganti dengan kunci API Anda

  Future<Weather?> getCurrentWeather(double lat, double lon) async {
    try {
      return await _wf.currentWeatherByLocation(lat, lon);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
