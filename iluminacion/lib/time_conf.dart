import 'package:flutter/material.dart';
import 'package:vrcelights/mqttClientWrapper3.dart';

class ChangeTime extends StatelessWidget {
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

class ChangeTimeState extends StatefulWidget {
  ChangeTimeState({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChangeTimeState createState() => _ChangeTimeState();
}

class _ChangeTimeState extends State<ChangeTimeState> {
  int segs = 1;
  Color theColor;
  var foregroundColor;

  MQTTClientWrapper mqttClientWrapper3;

  void setup() {
    mqttClientWrapper3 = MQTTClientWrapper();
    mqttClientWrapper3.prepareMqttClients();
  }

  Widget iconMain = Container(
    //margin: new EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Image.asset('assets/images/time.png'),
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
                    value: segs.toDouble(),
                    label: segs.toString(),
                    min: 1,
                    max: 15,
                    divisions: 15,
                    onChanged: (double newValue) {
                      setState(() => segs = newValue.toInt());
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget exampleTimes() => Container(
        width: 260,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  child: Text('1',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {segs = 1});
                  }),
              MaterialButton(
                  child: Text('3',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {segs = 3});
                  }),
              MaterialButton(
                  child: Text('5',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {segs = 5});
                  }),
              MaterialButton(
                  child: Text('10',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {segs = 10});
                  }),
              MaterialButton(
                  child: Text('15',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {segs = 15});
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
                        Text("SELECT TIME",
                            style: TextStyle(
                                color: Color(0xFFB8B8B8), fontSize: 24))
                      ],
                    )),
                  ],
                ),
              ),
              exampleTimes(),
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
                  child: Text('$segs segs',
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
                    setState(() => {mqttClientWrapper3.publishTime('$segs')});
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
