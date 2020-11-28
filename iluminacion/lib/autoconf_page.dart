import 'package:flutter/material.dart';
import 'package:vrcelights/home_page.dart';
import 'package:vrcelights/color_conf.dart';
import 'package:vrcelights/time_conf.dart';
import 'package:vrcelights/distance_conf.dart';

class MyConfigAuto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "aconfpage",
      title: 'Config Auto',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => MyHomePage(),
        '/aconfpage': (context) => MyConfigAutoState(),
      },
    );
  }
}

class MyConfigAutoState extends StatefulWidget {
  MyConfigAutoState({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyConfigAutoState createState() => _MyConfigAutoState();
}

class _MyConfigAutoState extends State<MyConfigAutoState> {
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
                margin: new EdgeInsets.fromLTRB(0, 80, 0, 50),
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
                        margin: EdgeInsets.only(left: 30),
                        child: Text("CONFIG AUTO",
                            style: TextStyle(
                                color: Color(0xFFB8B8B8), fontSize: 24))),
                  ],
                ),
              ),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 5, color: Color(0xFFFFD600))),
                  minWidth: 260.0,
                  height: 60.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeTimeState()),
                    );
                  },
                  child: Text('TIME',
                      style: TextStyle(color: Color(0xFFB8B8B8), fontSize: 18)),
                ),
              ),
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
                          builder: (context) => ChangeDistanceState()),
                    );
                  },
                  child: Text('DISTANCE',
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
