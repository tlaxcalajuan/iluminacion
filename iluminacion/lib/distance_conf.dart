import 'package:flutter/material.dart';
import 'package:vrcelights/mqttClientWrapper2.dart';

class ChangeDistance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "mconfpage",
      title: 'Config Manual',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

MQTTClientWrapper2 mqttClientWrapper2;

void setup() {
  mqttClientWrapper2 = MQTTClientWrapper2();
  mqttClientWrapper2.prepareMqttClients();
}

class ChangeDistanceState extends StatefulWidget {
  ChangeDistanceState({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChangeDistanceState createState() => _ChangeDistanceState();
}

class _ChangeDistanceState extends State<ChangeDistanceState> {
  int centimeters = 50;
  Color theColor;
  var foregroundColor;

  Widget iconMain = Container(
    //margin: new EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Image.asset('assets/images/distance.png'),
    width: 320,
    height: 160,
  );

  Widget rowSliders() => Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                width: 260,
                child: SliderTheme(
                  data: SliderThemeData(),
                  child: Slider(
                    inactiveColor: Color(0xFFB8B8B8),
                    activeColor: Color(0xFFFFD600),
                    value: centimeters.toDouble(),
                    label: centimeters.toString(),
                    min: 50,
                    max: 350,
                    divisions: 350,
                    onChanged: (double newValue) {
                      setState(() => {centimeters = newValue.toInt()});
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget exampleDistances() => Container(
        width: 260,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  child: Text('50',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 30.0,
                  height: 30.0,
                  onPressed: () {
                    setState(() => {centimeters = 50});
                  }),
              MaterialButton(
                  child: Text('100',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 30.0,
                  height: 30.0,
                  onPressed: () {
                    setState(() => {centimeters = 100});
                  }),
              MaterialButton(
                  child: Text('200',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 30.0,
                  height: 30.0,
                  onPressed: () {
                    setState(() => {centimeters = 200});
                  }),
              MaterialButton(
                  child: Text('300',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 30.0,
                  height: 30.0,
                  onPressed: () {
                    setState(() => {centimeters = 300});
                  }),
              MaterialButton(
                  child: Text('350',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 30.0,
                  height: 30.0,
                  onPressed: () {
                    setState(() => {centimeters = 350});
                  })
            ],
          ),
        ),
      );
  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: new EdgeInsets.fromLTRB(0, 80, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SELECT DISTANCE",
                            style: TextStyle(
                                color: Color(0xFFB8B8B8), fontSize: 24))
                      ],
                    )),
                  ],
                ),
              ),
              exampleDistances(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: <Widget>[
                    iconMain,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[rowSliders()],
                    ),
                  ],
                ),
                width: 260,
              ),
              Container(
                margin: new EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: MaterialButton(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 150.0,
                  height: 60.0,
                  onPressed: () {},
                  child: Text('$centimeters cm',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              Container(
                margin: new EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: MaterialButton(
                  color: Color(0xFFFFD600),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 260.0,
                  height: 60.0,
                  onPressed: () {
                    setState(() =>
                        {mqttClientWrapper2.publishDistance('$centimeters')});
                    Navigator.pop(context);
                  },
                  child: Text('SAVE',
                      style: TextStyle(color: Color(0xFF000000), fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
