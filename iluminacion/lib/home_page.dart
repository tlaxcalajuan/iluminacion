import 'package:flutter/material.dart';
import 'package:vrcelights/autoconf_page.dart';
import 'package:vrcelights/manualconf_page.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VRCE light',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //CERATE WIDGETS
    Widget title = Container(
      margin: new EdgeInsets.fromLTRB(0, 100, 0, 30),
      child: Text(
        'ILUMINATION VRCE',
        style: TextStyle(color: Color(0xFFB8B8B8), fontSize: 24),
      ),
    );

    Widget iconMain = Container(
      margin: new EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Image.asset('assets/images/iconHome.png'),
      width: 320,
      height: 160,
    );

    Widget btnAuto = Container(
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
            MaterialPageRoute(builder: (context) => MyConfigAutoState()),
          );
          // Navigator.of(context).pushNamed("/aconfpage");
        },
        child: Text('AUTOMATIC',
            style: TextStyle(color: Color(0xFFB8B8B8), fontSize: 18)),
      ),
    );

    Widget btnManual = Container(
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
            MaterialPageRoute(builder: (context) => MyConfigManualState()),
          );
        },
        child: Text('MANUAL',
            style: TextStyle(color: Color(0xFFB8B8B8), fontSize: 18)),
      ),
    );

    Widget logoVRCE = Container(
      margin: new EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image.asset('assets/images/vrcelogo.png'),
      width: 80,
      height: 40,
    );

    // VISTA PRINCIPAL
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Container(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              title,
              iconMain,
              btnAuto,
              btnManual,
              logoVRCE,
            ],
          ),
        ),
      ),
    );
  }
}
