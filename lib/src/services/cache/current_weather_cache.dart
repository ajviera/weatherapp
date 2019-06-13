import 'dart:convert';

import 'package:weather_app/src/common/prefs_singleton.dart';
import 'package:weather_app/src/services/cache/cache.dart';

class CurrentWeatherCache implements Cache {
  @override
  fetch() {
    var currentWeatherCache =
        PrefsSingleton.prefs.getString('currentWeatherCache');
    if (currentWeatherCache != null) {
      var purchasesJson = json.decode(currentWeatherCache.toString());
      return purchasesJson;
    }
    return currentWeatherCache;
  }

  @override
  save(var element) {
    PrefsSingleton.prefs.setString('currentWeatherCache', element);
  }

  @override
  clean() {
    PrefsSingleton.prefs.remove('currentWeatherCache');
  }
}
