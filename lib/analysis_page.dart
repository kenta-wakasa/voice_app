import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wave_painter.dart';

import 'analysis_model.dart';

class AnalyisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnalysisModel>(
      create: (_) => AnalysisModel()..initPlugin(),
      child: Consumer<AnalysisModel>(builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: CustomPaint(
              painter: WavePainter(model.samples, Colors.white, context),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (model.isRecording) {
                model.stopRecorder();
              } else {
                model.startRecorder();
              }
            },
            child: model.isRecording
                ? const Icon(Icons.mic)
                : const Icon(Icons.mic_off),
          ),
        );
      }),
    );
  }
}
