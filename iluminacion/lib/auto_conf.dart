import 'package:flutter/material.dart';

class MyAutoPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AutoconfPage(title: 'Flutter Demo Auto Page'),
    );
  }
}

class AutoconfPage extends StatefulWidget {
  AutoconfPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AutoconfPageState createState() => _AutoconfPageState();
}

class _AutoconfPageState extends State<AutoconfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
