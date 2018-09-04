library weatherapp;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

part 'common/strings.dart';
part 'common/ui.dart';

part 'models/weather.dart';

part 'screens/home_page.dart';

part 'services/weather_api.dart';

part 'utils/keys.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}
