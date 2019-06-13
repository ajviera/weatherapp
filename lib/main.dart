import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/src/common/prefs_singleton.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  PrefsSingleton.prefs = await SharedPreferences.getInstance();

  runApp(new WeatherApp());
}
