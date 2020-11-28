import 'package:flutter/material.dart';
import 'package:vrcelights/home_page.dart';
import 'package:vrcelights/color_conf.dart';
import 'package:vrcelights/mqttClientWrapper.dart';

class MyConfigManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "mconfpage",
      title: 'Config Manual',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => MyHomePage(),
        '/mconfpage': (context) => MyConfigManual(),
      },
    );
  }
}

class MyConfigManualState extends StatefulWidget {
  MyConfigManualState({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  _MyConfigManualState createState() => _MyConfigManualState();
}

class _MyConfigManualState extends State<MyConfigManualState> {
  bool isSwitched = false;
  int colorStateR = 255;
  int colorStateG = 255;
  int colorStateB = 255;

  MQTTClientWrapper mqttClientWrapper;

  void setup() {
    mqttClientWrapper = MQTTClientWrapper();
    mqttClientWrapper.prepareMqttClients();
  }

  Widget iconMain() => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color:
                    Color.fromRGBO(colorStateR, colorStateG, colorStateB, 1.0),
                width: 4)),
        margin: new EdgeInsets.fromLTRB(0, 10, 0, 30),
        child: Image.asset('assets/images/onoff.png'),
        width: 320,
        height: 160,
      );

  Widget switchON() => Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() => {
                isSwitched = value,
                if (isSwitched == false)
                  {
                    mqttClientWrapper.publishStatus("off"),
                    colorStateR = 184,
                    colorStateG = 184,
                    colorStateB = 184
                  }
                else
                  {
                    mqttClientWrapper.publishStatus("on"),
                    colorStateR = 255,
                    colorStateG = 214,
                    colorStateB = 0,
                  }
              });
        },
        inactiveTrackColor: Colors.white,
        activeTrackColor: Color(0xFFB8B8B8),
        activeColor: Color(0xFFFFD600),
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
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: new EdgeInsets.fromLTRB(0, 80, 0, 30),
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
                        //margin: EdgeInsets.only(left: 10),
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("CONFIG MANUAL",
                            style: TextStyle(
                                color: Color(0xFFB8B8B8), fontSize: 24))
                      ],
                    )),
                  ],
                ),
              ),
              iconMain(),
              switchON(),
              Container(),
              Container(
                margin: new EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 260.0,
                  height: 60.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeColorState()),
                    );
                  },
                  child: Text('COLOR',
                      style: TextStyle(color: Color(0xFFB8B8B8), fontSize: 18)),
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
