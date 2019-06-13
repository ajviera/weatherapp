import 'package:flutter/material.dart';
import 'package:weather_app/src/providers/app_change_notifier.dart';
import 'package:weather_app/src/screens/home_page.dart';
import 'package:provider/provider.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppGeneralNotifier>(
          builder: (_) => AppGeneralNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(fontFamily: 'Noir'),
        home: WeatherPage(),
      ),
    );
  }
}
