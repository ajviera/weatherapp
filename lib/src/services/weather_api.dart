import 'dart:convert';

import 'package:weather_app/src/common/config.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  String baseUrl = 'https://api.openweathermap.org/data/2.5/';
  String query =
      '?q=Buenos Aires,ar&units=metric&lang=es&appid=${Config.openWeatherMapKey}';

  Future<Weather> getCurrentWeather() async {
    final apiUrl = baseUrl + 'weather' + query;
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Weather>> getNextWeather() async {
    final apiUrl = baseUrl + 'forecast' + query;
    final response = await http.get(apiUrl);
    List<Weather> weathers = List<Weather>();
    if (response.statusCode == 200) {
      Map responseList = json.decode(response.body);
      weathers.addAll(_getList(responseList['list']));
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
}
