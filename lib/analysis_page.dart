import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wave_painter.dart';

import 'analysis_model.dart';

class AnalyisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnalysisModel>(
      create: (_) => AnalysisModel()..start(),
      child: Consumer<AnalysisModel>(builder: (context, model, child) {
        return Scaffold(
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              backgroundColor: model.isRecording ? Colors.red : Colors.green,
              onPressed: model.isRecording ? model.stop : model.start,
              child: model.isRecording
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.mic),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // constraints variable has the size info
                    return CustomPaint(
                      painter:
                          WavePainter(model.spectrum, Colors.blue, constraints),
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      children: axis(constraints),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> axis(BoxConstraints constraints) {
    final list = <Widget>[];
    const maxFrequency = 44100 / 4;
    for (var i = 0; i < (maxFrequency / 1000); i++) {
      list.add(
        Positioned(
          bottom: 0,
          left: i * (constraints.maxWidth / (maxFrequency / 1000)),
          child: Text(
            '${i}k',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return list;
  }
}
