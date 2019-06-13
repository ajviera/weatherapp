import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:weather_app/src/providers/app_change_notifier.dart';
import 'package:weather_app/src/services/weather_api.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app/src/themes/ui.dart';
import 'package:weather_app/src/widgets/color_loader_popup.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Weather> _nextWeather;
  Weather _currentWeather;
  DateTime _timeNow;
  bool _isBlocked;
  bool _isLoading;
  WeatherApi weatherApi;

  @override
  void initState() {
    weatherApi = WeatherApi();
    initializeDateFormatting("es_AR", null);
    _isBlocked = false;
    _isLoading = true;
    super.initState();
  }

  void _initializeInfo(context) {
    weatherApi.getCurrentWeather().then((result) {
      _currentWeather = result;
      weatherApi.getNextWeather().then((result) {
        _nextWeather = result;
        setState(() {
          _isBlocked = true;
          _timeNow = DateTime.now();
          if (_currentWeather != null)
            Provider.of<AppGeneralNotifier>(context).setBackgroundImage(
              weather: _currentWeather,
            );
          _isLoading = false;
        });
      });
    });
  }

  void _refreshWeatherInfo(context) {
    if (!_isBlocked) _initializeInfo(context);

    Future.delayed(const Duration(minutes: 5), () {
      setState(() => _isBlocked = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshWeatherInfo(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Provider.of<AppGeneralNotifier>(context)
                    .getBackgroundImage(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _isLoading ? ColorLoaderPopup() : _body(),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      color: Colors.black.withOpacity(0.25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _place(),
          Expanded(child: buildCurrentWeather()),
          buildNextWeather(),
        ],
      ),
    );
  }

  Widget _place() {
    return Container(
      padding: const EdgeInsets.only(top: 125.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Buenos Aires',
            style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
          Text(
            '${DateFormat.Hm().format(_timeNow)}',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Center _errorCase() {
    return Center(
      child: SizedBox(
        width: 250.0,
        child: Text(
          'No se pudo obtener la información',
          style: TextStyle(color: Colors.white, fontSize: 25.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildNextWeather() {
    return _nextWeather == null
        ? SizedBox()
        : Container(
            height: 180.0,
            padding: const EdgeInsets.only(bottom: 60.0),
            child: ListView.builder(
              addRepaintBoundaries: true,
              scrollDirection: Axis.horizontal,
              itemCount: _nextWeather.length,
              itemBuilder: (BuildContext context, int index) {
                return _weatherBoxCard(_nextWeather, index);
              },
            ),
          );
  }

  Card _weatherBoxCard(List<Weather> data, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      color: Colors.transparent,
      elevation: 0.0,
      child: SizedBox(
        height: 100.0,
        width: 170.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '${DateFormat.yMd().format(DateTime.parse(data[index].date))}',
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                  Text(
                    '${DateFormat.Hm().format(DateTime.parse(data[index].date))}',
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'https://openweathermap.org/img/w/${data[index].icon}.png',
                    color: Colors.white,
                  ),
                  Text(
                    data[index].temp.round().toString() + 'º',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrentWeather() {
    return _currentWeather == null
        ? _errorCase()
        : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(
                    'https://openweathermap.org/img/w/${_currentWeather.icon}.png',
                    fit: BoxFit.cover,
                    height: 100.0,
                    width: 100.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _currentWeather.temp.round().toString() + 'º',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
