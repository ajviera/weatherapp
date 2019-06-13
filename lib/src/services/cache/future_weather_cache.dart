import 'dart:convert';

import 'package:weather_app/src/common/prefs_singleton.dart';
import 'package:weather_app/src/services/cache/cache.dart';

class FutureWeatherCache implements Cache {
  @override
  fetch() {
    var futureWeatherCache =
        PrefsSingleton.prefs.getString('futureWeatherCache');
    if (futureWeatherCache != null) {
      var purchasesJson = json.decode(futureWeatherCache.toString());
      return purchasesJson;
    }
    return futureWeatherCache;
  }

  @override
  save(var element) {
    PrefsSingleton.prefs.setString('futureWeatherCache', element);
  }

  @override
  clean() {
    PrefsSingleton.prefs.remove('futureWeatherCache');
  }
}
