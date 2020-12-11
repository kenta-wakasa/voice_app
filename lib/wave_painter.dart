import 'dart:math';

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final _hightOffset = 0.25;
  BoxConstraints constraints;
  List<double> samples;
  List<Offset> points;
  Color color;

  Size size;

  // Set max val possible in stream, depending on the config
  final absMax = 30;

  WavePainter(this.samples, this.color, this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    // this.size = context.size;
    // size = this.size;

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
  List<Offset> toPoints(List<double> samples) {
    final points = <Offset>[];
    for (var i = 0; i < (samples.length / 2); i++) {
      points.add(
        Offset(
          i / (samples.length / 2) * constraints.maxWidth,
          project(samples[i], absMax, constraints.maxHeight),
        ),
      );
    }
    return points;
  }

  double project(double val, int max, double height) {
    final waveHeight = (val / max) * _hightOffset * height;
    return waveHeight + _hightOffset * height;
  }
}
