import 'package:flutter/material.dart';
import 'package:vrcelights/home_page.dart';
import 'package:vrcelights/mqttClientWrapper4.dart';

class ChangeColor extends StatelessWidget {
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
        '/mconfpage': (context) => ChangeColor(),
      },
    );
  }
}

class ChangeColorState extends StatefulWidget {
  ChangeColorState({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChangeColorState createState() => _ChangeColorState();
}

class _ChangeColorState extends State<ChangeColorState> {
  String serverResponse = 'Server response';

  int colorlightR = 0;
  int colorlightG = 0;
  int colorlightB = 0;

  Color theColor;
  var foregroundColor;

  MQTTClientWrapper mqttClientWrapper4;

  void setup() {
    mqttClientWrapper4 = MQTTClientWrapper();
    mqttClientWrapper4.prepareMqttClients();
  }

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
                    activeColor: Color.fromRGBO(255, 0, 0, 1.0),
                    value: colorlightR.toDouble(),
                    label: colorlightR.toString(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (double newValue) {
                      setState(() => {
                            mqttClientWrapper4.publishColor(
                                '$colorlightR,$colorlightG,$colorlightB'),
                            colorlightR = newValue.toInt()
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 260,
                child: SliderTheme(
                  data: SliderThemeData(),
                  child: Slider(
                    inactiveColor: Color(0xFFB8B8B8),
                    activeColor: Color.fromRGBO(0, 255, 0, 1.0),
                    value: colorlightG.toDouble(),
                    label: colorlightG.toString(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (double newValue) {
                      setState(() => {
                            mqttClientWrapper4.publishColor(
                                '$colorlightR,$colorlightG,$colorlightB'),
                            colorlightG = newValue.toInt()
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 260,
                child: SliderTheme(
                  data: SliderThemeData(),
                  child: Slider(
                    inactiveColor: Color(0xFFB8B8B8),
                    activeColor: Color.fromRGBO(0, 0, 255, 1.0),
                    value: colorlightB.toDouble(),
                    label: colorlightB.toString(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (double newValue) {
                      setState(() => {
                            mqttClientWrapper4.publishColor(
                                '$colorlightR,$colorlightG,$colorlightB'),
                            colorlightB = newValue.toInt()
                          });
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget exampleColors() => Container(
        //color: Colors.white,
        width: 260,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  //rgb(52, 206, 240,1.0)
                  color: Color.fromRGBO(52, 206, 240, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          width: 5, color: Color.fromRGBO(52, 206, 240, 1.0))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {
                          colorlightR = 52,
                          colorlightG = 206,
                          colorlightB = 240,
                          mqttClientWrapper4.publishColor(
                              '$colorlightR,$colorlightG,$colorlightB')
                        });
                  }),
              MaterialButton(
                  //rgb(255, 0, 46,1.0)
                  color: Color.fromRGBO(255, 0, 46, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          width: 5, color: Color.fromRGBO(255, 0, 46, 1.0))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {
                          colorlightR = 255,
                          colorlightG = 0,
                          colorlightB = 46,
                          mqttClientWrapper4.publishColor(
                              '$colorlightR,$colorlightG,$colorlightB')
                        });
                  }),
              MaterialButton(
                  //rgb(6, 243, 44,1.0)
                  color: Color.fromRGBO(6, 243, 44, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          width: 5, color: Color.fromRGBO(6, 243, 44, 1.0))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {
                          colorlightR = 6,
                          colorlightG = 243,
                          colorlightB = 44,
                          mqttClientWrapper4.publishColor(
                              '$colorlightR,$colorlightG,$colorlightB')
                        });
                  }),
              MaterialButton(
                  //rgb(255, 214, 0,1.0)
                  color: Color.fromRGBO(255, 214, 0, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          width: 5, color: Color.fromRGBO(255, 214, 0, 1.0))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {
                          colorlightR = 255,
                          colorlightG = 214,
                          colorlightB = 0,
                          mqttClientWrapper4.publishColor(
                              '$colorlightR,$colorlightG,$colorlightB')
                        });
                  }),
              MaterialButton(
                  //rgb(255, 255, 255,1.0)
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          width: 5, color: Color.fromRGBO(255, 255, 255, 1.0))),
                  minWidth: 40.0,
                  height: 40.0,
                  onPressed: () {
                    setState(() => {
                          colorlightR = 255,
                          colorlightG = 255,
                          colorlightB = 255,
                          mqttClientWrapper4.publishColor(
                              '$colorlightR,$colorlightG,$colorlightB')
                        });
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
            //mainAxisAlignment: MainAxisAlignment.center,
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
                        //margin: EdgeInsets.only(left: 10),
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SELECT COLOR",
                            style: TextStyle(
                                color: Color(0xFFB8B8B8), fontSize: 24))
                      ],
                    )),
                  ],
                ),
              ),
              exampleColors(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),

                //color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[rowSliders()],
                    ),
                  ],
                ),
                width: 260,
              ),
              Container(
                margin: new EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: MaterialButton(
                  color: theColor = Color.fromRGBO(
                      colorlightR, colorlightG, colorlightB, 1.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFB8B8B8))),
                  minWidth: 150.0,
                  height: 60.0,
                  onPressed: () {
                    //Navigator.pushNamed(context, "/aconfpage");
                    setState(() => {});
                  },
                  child: Text(
                      '$colorlightR,' + '$colorlightG,' + '$colorlightB',
                      style: TextStyle(
                          color: foregroundColor =
                              theColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 18)),
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
                    setState(() => {});
                    Navigator.pop(context);
                  },
                  child: Text('SAVE',
                      style: TextStyle(color: Color(0xFF000000), fontSize: 18)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(serverResponse),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
