import "package:flutter/material.dart";
import "package:flutter_map/plugin_api.dart";

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
  final MapController _mapController = MapController();
  var interactiveFlags = InteractiveFlag.rotate |
      InteractiveFlag.doubleTapZoom |
      InteractiveFlag.pinchZoom |
      InteractiveFlag.drag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MtbMap Norge"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(interactiveFlags: interactiveFlags),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ["a", "b", "c"],
            attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
            },
          ),
        ],
      ),
    );
  }
}
