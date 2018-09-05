part of weatherapp;

class WeatherApi {
  String _openWeatherMap = Keys.openWeatherMap;

  Future<Weather> getCurrentWeather() async {
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=Buenos Aires,ar&units=metric&lang=es&appid=$_openWeatherMap';
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudo obtener la información');
    }
  }

  Future<List<Weather>> getNextWeather() async {
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=Buenos Aires,ar&units=metric&lang=es&appid=$_openWeatherMap';
    final response = await http.get(apiUrl);
    List<Weather> weathers = List<Weather>();
    if (response.statusCode == 200) {
      Map responseList = json.decode(response.body);
      weathers.addAll(_getList(responseList['list']));
    } else {
      throw Exception('No se pudo obtener la información');
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
        icon: weather['weather'][0]['icon'],
        humidity: weather['weather'][0]['humidity'],
        tempMax: weather['weather'][0]['temp_max'],
        tempMin: weather['weather'][0]['temp_min'],
      );
    }).toList();
  }
}
