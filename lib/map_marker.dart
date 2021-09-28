import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:mtbmap_demo/src/location_provider.dart";
import "package:provider/provider.dart";
import "dart:math";

class MapMarker extends StatelessWidget {
  const MapMarker({Key? key}) : super(key: key);

  Widget _marker() {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return StreamBuilder(
      stream: locationProvider.locationStream,
      builder: (context, AsyncSnapshot<Position> snapshot) {
        return Stack(
          children: <Widget>[
            if (snapshot.hasData)
              Transform(
                transform: Matrix4.rotationZ(pi),
                alignment: Alignment.center,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(snapshot.data!.heading / 360),
                  child: CustomPaint(
                    size: Size(100, 100),
                    painter: DrawTriangle(),
                  ),
                ),
              ),
            Center(child: _marker()),
          ],
        );
      },
    );
  }
}

class DrawTriangle extends CustomPainter {
  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = RadialGradient(
      center: Alignment.topCenter, // near the top right
      radius: 1.2,
      colors: [Colors.blue, Colors.white10],
      stops: [0.6, 1.0],
    );
    _paint = Paint();
    _paint.style = PaintingStyle.fill;
    _paint.shader = gradient.createShader(rect);
    var path = Path();
    path.moveTo(size.width / 4, size.height);
    path.lineTo((size.width / 4) * 3, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
