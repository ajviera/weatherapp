part of weatherapp;

class Weather {
  double lat;
  double lgn;
  String description;
  String icon;
  double temp;
  int humidity;
  int tempMin;
  int tempMax;
  int visibility;
  double windSpeed;
  // sunrise;
  // sunset;

  Weather({
    this.lat,
    this.lgn,
    this.description,
    this.icon,
    this.temp,
    this.humidity,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      lat: json['coord']['lat'],
      lgn: json['coord']['lon'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temp: json['main']['temp'],
      humidity: json['main']['humidity'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      visibility: json['visibility'],
      windSpeed: json['wind']['speed'],
    );
  }
}
