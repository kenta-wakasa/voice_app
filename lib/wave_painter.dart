import 'dart:math';

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final _hightOffset = 0.5;
  List<int> samples;
  List<Offset> points;
  Color color;
  BuildContext context;
  Size size;

  // Set max val possible in stream, depending on the config
  final int absMax = 500000;

  WavePainter(this.samples, this.color, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = context.size;
    size = this.size;

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    points = toPoints(samples);

    Path path = Path();
    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldPainting) => true;

  // Maps a list of ints and their indices to a list of points on a cartesian grid
  List<Offset> toPoints(List<int> samples) {
    final points = <Offset>[];
    var samplesToDouble = <double>[];
    if (samples == null) {
      samplesToDouble =
          List<double>.filled(pow(2, 13).toInt(), _hightOffset * size.height);
    }
    for (var i = 0; i < size.width; i++) {
      points.add(
        Offset(
          i * 1.0,
          project(samples[i], absMax, size.height),
        ),
      );
    }
    return points;
  }

  double project(int val, int max, double height) {
    final waveHeight = (val / max) * _hightOffset * height;
    return waveHeight + _hightOffset * height;
  }
}
