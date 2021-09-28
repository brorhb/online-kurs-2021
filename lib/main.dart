import "package:flutter/material.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MtbMap(),
    );
  }
}

class MtbMap extends StatefulWidget {
  const MtbMap({Key? key}) : super(key: key);

  @override
  _MtbMapState createState() => _MtbMapState();
}

class _MtbMapState extends State<MtbMap> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello world"),
      ),
    );
  }
}
