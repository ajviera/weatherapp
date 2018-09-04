part of weatherapp;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _selectImage(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: <Widget>[
                  FutureBuilder<Weather>(
                    future: WeatherApi().getCurrentWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return weatherWidget(snapshot);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  // Container(
                  //   padding: const EdgeInsets.only(top: 150.0),
                  //   child: FutureBuilder<List<Weather>>(
                  //     future: WeatherApi().getNextWeather(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return listOfWeatherWidget(snapshot.data);
                  //       } else if (snapshot.hasError) {
                  //         return Center(child: Text("${snapshot.error}"));
                  //       }
                  //       return Center(child: CircularProgressIndicator());
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listOfWeatherWidget(List<Weather> data) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.length == null ? 0 : data,
      itemBuilder: (context, i) {
        Text(data[i].temp.toString());
      },
    );
  }

  AssetImage _selectImage() {
    var _hour = DateTime.now().hour;
    if (_hour > 8 && _hour < 20) {
      return Ui.dayDackgroundImage;
    } else {
      return Ui.nightDackgroundImage;
    }
  }

  Widget weatherWidget(AsyncSnapshot<Weather> snapshot) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 150.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Buenos Aires',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
              ),
            ),
            Text(
              '${DateFormat.Hm().format(DateTime.now())}',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  snapshot.data.temp.round().toString() + 'º',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                  ),
                ),
                Container(
                  child: Image.network(
                    'http://openweathermap.org/img/w/${snapshot.data.icon}.png',
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
