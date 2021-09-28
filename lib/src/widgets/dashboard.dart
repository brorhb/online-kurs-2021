import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtbmap_demo/src/location_provider.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);

    return StreamBuilder<Position>(
      stream: locationProvider.locationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 60,
            width: (MediaQuery.of(context).size.width / 3) * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${snapshot.data!.speed} m/s"),
                  Text("${snapshot.data!.altitude} moh")
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
