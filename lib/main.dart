import "package:flutter/material.dart";
import "package:flutter_map/plugin_api.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";
import "package:mtbmap_demo/map_marker.dart";
import "package:mtbmap_demo/src/location_provider.dart";
import 'package:mtbmap_demo/src/widgets/dashboard.dart';
import "package:provider/provider.dart";

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
  bool tracking = true;
  var interactiveFlags = InteractiveFlag.rotate |
      InteractiveFlag.doubleTapZoom |
      InteractiveFlag.pinchZoom |
      InteractiveFlag.drag;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        LocationProvider locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        _mapController.move(LatLng(62.5942, 9.6912), 12);
        locationProvider.locationStream.listen((event) {
          if (tracking) {
            _mapController.moveAndRotate(
              LatLng(event.latitude, event.longitude),
              _mapController.zoom,
              -event.heading,
            );
          }
        });
        _mapController.mapEventStream.listen((event) {
          if (tracking && event.source == MapEventSource.onDrag) {
            setState(() {
              tracking = false;
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder<Position>(
      stream: locationProvider.locationStream,
      builder: (context, snapshot) {
        Marker? marker;
        if (snapshot.hasData) {
          marker = Marker(
            width: 50,
            height: 50,
            point: LatLng(
              snapshot.data!.latitude,
              snapshot.data!.longitude,
            ),
            builder: (context) {
              return MapMarker();
            },
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("MtbMap Norge"),
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(interactiveFlags: interactiveFlags),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ["a", "b", "c"],
                    attributionBuilder: (_) {
                      return Text("© OpenStreetMap contributors");
                    },
                  ),
                  MarkerLayerOptions(
                    markers: [
                      if (marker != null) marker,
                    ],
                  )
                ],
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Dashboard(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child:
                Icon(tracking ? Icons.navigation : Icons.navigation_outlined),
            onPressed: () {
              setState(() {
                tracking = !tracking;
              });
              if (tracking && snapshot.hasData) {
                _mapController.moveAndRotate(
                  LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                  _mapController.zoom,
                  -snapshot.data!.heading,
                );
              } else {
                _mapController.moveAndRotate(
                  _mapController.center,
                  _mapController.zoom,
                  0,
                );
              }
            },
          ),
        );
      },
    );
  }
}
