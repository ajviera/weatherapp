import 'dart:convert';

import 'package:weather_app/src/common/config.dart';
import 'package:weather_app/src/common/prefs_singleton.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/src/services/cache/current_weather_cache.dart';
import 'package:weather_app/src/services/cache/future_weather_cache.dart';

class WeatherApi {
  String baseUrl = 'https://api.openweathermap.org/data/2.5/';
  String query =
      '?q=Buenos Aires,ar&units=metric&lang=es&appid=${Config.openWeatherMapKey}';

  Future<Weather> getCurrentWeather() async {
    if (_canFetch(PrefsSingleton.prefs.getString('currentWeatherLastFetch'))) {
      return await _fetchCurrentWeatherFromAPI();
    } else {
      var fetchResult = CurrentWeatherCache().fetch();
      return Weather.fromJson(fetchResult);
    }
  }

  Future<Weather> _fetchCurrentWeatherFromAPI() async {
    final apiUrl = baseUrl + 'weather' + query;
    final response = await http.get(apiUrl);
    var resultUtf = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      CurrentWeatherCache().save(resultUtf.toString());
      _addCurrentWeatherLastFetch();
      return Weather.fromJson(json.decode(resultUtf));
    } else {
      return null;
    }
  }

  Future<List<Weather>> getNextWeather() async {
    if (_canFetch(PrefsSingleton.prefs.getString('nextWeatherLastFetch'))) {
      return await _fetchNextWeatherFromAPI();
    } else {
      List<Weather> weathers = List<Weather>();
      var fetchResult = FutureWeatherCache().fetch();
      weathers.addAll(_getList(fetchResult['list']));
      return weathers;
    }
  }

  Future<List<Weather>> _fetchNextWeatherFromAPI() async {
    List<Weather> weathers = List<Weather>();

    final apiUrl = baseUrl + 'forecast' + query;
    final response = await http.get(apiUrl);
    var resultUtf = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      FutureWeatherCache().save(resultUtf.toString());
      Map responseList = json.decode(resultUtf);
      weathers.addAll(_getList(responseList['list']));
      _addNextWeatherLastFetch();
    } else {
      return null;
    }
    return weathers;
  }

  _getList(List responseList) {
    return responseList.map<Weather>((weather) {
      return Weather(
        temp: weather['main']['temp'],
        date: weather['dt_txt'],
        windSpeed: weather['wind']['speed'],
        description: weather['weather'][0]['description'],
        main: weather['weather'][0]['main'],
        icon: weather['weather'][0]['icon'],
        humidity: weather['weather'][0]['humidity'],
        tempMax: weather['weather'][0]['temp_max'],
        tempMin: weather['weather'][0]['temp_min'],
      );
    }).toList();
  }

  bool _canFetch(String lastFetch) {
    bool aux = lastFetch != null;

    if (aux) {
      return DateTime.parse(lastFetch)
          .add(Duration(minutes: 5))
          .isBefore(DateTime.now());
    }
    return true;
  }

  _addCurrentWeatherLastFetch() {
    PrefsSingleton.prefs.setString(
      'currentWeatherLastFetch',
      DateTime.now().toIso8601String(),
    );
  }

  _addNextWeatherLastFetch() {
    PrefsSingleton.prefs.setString(
      'nextWeatherLastFetch',
      DateTime.now().toIso8601String(),
    );
  }
}
