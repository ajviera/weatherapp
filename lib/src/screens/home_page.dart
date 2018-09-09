part of weatherapp;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();
  var _nextWeatherCall;
  var _currentWeatherCall;
  var _timeNow;
  var _backgroundImage;
  bool _isBlocked;

  @override
  void initState() {
    super.initState();
    _isBlocked = false;
    _initializeInfo();
  }

  void _initializeInfo() {
    setState(() {
      _backgroundImage = _selectImage();
      _timeNow = DateTime.now();
      _currentWeatherCall = WeatherApi().getCurrentWeather();
      _nextWeatherCall = WeatherApi().getNextWeather();
    });
  }

  void _refreshWeatherInfo() {
    _initializeInfo();
    setState(() {
      _isBlocked = true;
    });
    Timer(Duration(seconds: 60), () {
      setState(() {
        _isBlocked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildCurrentWeather(),
                  Expanded(child: Container()),
                  buildNextWeather(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 15.0,
              backgroundColor: _isBlocked ? Colors.grey : Color(0xFFE57373),
              child: Icon(Icons.refresh),
              onPressed: _isBlocked ? () => {} : () => _refreshWeatherInfo(),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildNextWeather() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: FutureBuilder<List<Weather>>(
        future: _nextWeatherCall,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return listOfWeatherWidget(snapshot);
          } else if (snapshot.hasError) {
            return Text('');
          }
          return Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 150.0),
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<Weather> buildCurrentWeather() {
    return FutureBuilder<Weather>(
      future: _currentWeatherCall,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return weatherWidget(snapshot);
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              padding: EdgeInsets.only(top: 200.0),
              child: Text(
                'No se pudo obtener la información',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        }
        return Center(
          child: Container(
            padding: EdgeInsets.only(top: 200.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget listOfWeatherWidget(AsyncSnapshot snapshot) {
    List<Weather> data = snapshot.data;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _controller,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _WeatherCard(
            data: data,
            index: index,
          );
        },
      ),
      // child: ListView.builder(
      //   addRepaintBoundaries: true,
      //   scrollDirection: Axis.horizontal,
      //   itemCount: data.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return _WeatherCard(data: data);
      //   },
      // ),
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
        padding: EdgeInsets.only(top: 180.0),
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
              '${DateFormat.Hm().format(_timeNow)}',
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

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({
    Key key,
    @required this.data,
    @required this.index,
  }) : super(key: key);

  final int index;
  final List<Weather> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      elevation: 8.0,
      color: Colors.blue.shade300,
      child: SizedBox(
        height: 100.0,
        width: 180.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${DateFormat.yMd().format(DateTime.parse(data[index].date))}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              Text(
                '${DateFormat.Hm().format(DateTime.parse(data[index].date))}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data[index].temp.round().toString() + 'º',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                    ),
                  ),
                  Container(
                    child: Image.network(
                      'http://openweathermap.org/img/w/${data[index].icon}.png',
                      color: Colors.white,
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
}
