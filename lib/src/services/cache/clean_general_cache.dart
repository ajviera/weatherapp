import 'package:weather_app/src/services/cache/current_weather_cache.dart';
import 'package:weather_app/src/services/cache/future_weather_cache.dart';

class CleanGeneralCache {
  execute() {
    _clean();
  }

  _clean() {
    CurrentWeatherCache().clean();
    FutureWeatherCache().clean();
  }
}
