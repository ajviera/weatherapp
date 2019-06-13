import 'package:flutter/material.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:weather_app/src/themes/ui.dart';
import 'dart:math' show Random;

class AppGeneralNotifier with ChangeNotifier {
  AssetImage _backgroundImage;
  Weather weather;
  Random randomizer = Random();

  AppGeneralNotifier() {
    _backgroundImage = AssetImage('assets/images/background.png');
  }

  getBackgroundImage() => _backgroundImage;

  void setBackgroundImage({Weather weather}) {
    this.weather = weather;
    _backgroundImage = _selectImage();
    notifyListeners();
  }

  _selectTimeOfTheDay() {
    var _hour = DateTime.now().hour;
    if (_hour > 7 && _hour < 18) {
      return 'day';
    } else if (_hour > 18 && _hour < 20) {
      return 'afternoon';
    } else {
      return 'night';
    }
  }

  AssetImage _selectImage() {
    var timeOfTheDat = _selectTimeOfTheDay();
    if (this.weather.main.toLowerCase() == 'thunderstorm') {
      return _thunderstormWeather(timeOfTheDat);
    } else if (this.weather.main.toLowerCase() == 'clear') {
      return _clearWeather(timeOfTheDat);
    } else if (this.weather.main.toLowerCase() == 'drizzle') {
      return _drizzleWeather(timeOfTheDat);
    } else if (this.weather.main.toLowerCase() == 'rain') {
      return _rainWeather(timeOfTheDat);
    } else if (this.weather.main.toLowerCase() == 'snow') {
      return _snowWeather(timeOfTheDat);
    } else if (this.weather.main.toLowerCase() == 'clouds') {
      return _cloudsWeather(timeOfTheDat);
    } else if (this.weather.main.toLowerCase() == 'mist' ||
        this.weather.main.toLowerCase() == 'smoke' ||
        this.weather.main.toLowerCase() == 'haze' ||
        this.weather.main.toLowerCase() == 'dust' ||
        this.weather.main.toLowerCase() == 'fog' ||
        this.weather.main.toLowerCase() == 'sand' ||
        this.weather.main.toLowerCase() == 'dust' ||
        this.weather.main.toLowerCase() == 'ash' ||
        this.weather.main.toLowerCase() == 'squall' ||
        this.weather.main.toLowerCase() == 'tornado') {
      return Ui.rainyDayMountainBackground;
    }
  }

  AssetImage _cloudsWeather(timeOfTheDat) {
    if (timeOfTheDat == 'day') {
      return Ui.rainyDayCityBackground;
    } else {
      return Ui.rainyDayOceanBackground;
    }
  }

  AssetImage _snowWeather(timeOfTheDat) {
    if (timeOfTheDat == 'day') {
      return Ui.snowyDayCityBackground;
    } else {
      return Ui.snowyDayMountainBackground;
    }
  }

  AssetImage _rainWeather(timeOfTheDat) {
    if (timeOfTheDat == 'day') {
      return Ui.rainyNightLighthouseBackground;
    } else {
      return Ui.rainyNightLighthouseBackground;
    }
  }

  AssetImage _drizzleWeather(timeOfTheDat) {
    if (timeOfTheDat == 'day') {
      return Ui.rainyDayOceanBackground;
    } else {
      return Ui.rainyNightLighthouseBackground;
    }
  }

  AssetImage _thunderstormWeather(timeOfTheDat) {
    if (timeOfTheDat == 'day') {
      return Ui.rainyNightLighthouseBackground;
    } else {
      return Ui.rainyNightLighthouseBackground;
    }
  }

  AssetImage _clearWeather(timeOfTheDat) {
    int numRandom = randomizer.nextInt(3);
    if (timeOfTheDat == 'day') {
      if (numRandom == 0) {
        return Ui.sunnyDayMountainBackground;
      } else {
        return Ui.sunnyDayCityBackground;
      }
    } else if (timeOfTheDat == 'afternoon') {
      if (numRandom == 0) {
        return Ui.sunnyAfternoonCityBackground;
      } else if (numRandom == 1) {
        return Ui.sunnyAfternoonCityBackground;
      } else {
        return Ui.sunnyAfternoonCityBackground;
      }
    } else {
      if (numRandom == 0) {
        return Ui.clearNightCityBackground;
      } else if (numRandom == 1) {
        return Ui.clearNightMountainBackground;
      } else {
        return Ui.clearNightCityBackground;
      }
    }
  }
}
