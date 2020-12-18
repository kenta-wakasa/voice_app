import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  WavePainter(this.samples, this.color, this.constraints);

  final _hightOffset = 0.25;
  BoxConstraints constraints;
  List<double> samples;
  List<Offset> points;
  Color color;

  Size size;

  // Set max val possible in stream, depending on the config
  final absMax = 30;

  @override
  void paint(Canvas canvas, Size size) {
    // 色、太さ、塗り潰しの有無などを指定
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 得られたデータをオフセットのリストに変換する
    // やっていることは決められた範囲で等間隔に点を並べているだけ
    points = toPoints(samples);

    // addPolygon で path をつくり deawPath でグラフを表現する
    final path = Path()..addPolygon(points, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldPainting) => true;

  // 得られたデータを等間隔に並べていく
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
