import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fft/fft.dart';
import 'package:flutter/material.dart';
import 'package:audio_streamer/audio_streamer.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:flutter/services.dart';

class AnalysisModel extends ChangeNotifier {
  final _streamer = AudioStreamer();
  final _windowLength = pow(2, 15).toInt();
  bool isRecording = false;
  List<double> audio = List<double>.filled(pow(2, 15).toInt(), 0);
  List<double> spectrum = List<double>.filled(pow(2, 15) ~/ 2, 0);

  void onAudio(List<double> buffer) {
    for (var i = 0; i < buffer.length; i++) {
      audio[i] = buffer[i];
    }
    final window = Window(WindowType.HAMMING);
    final windowed = window.apply(audio);
    final fft = FFT().Transform(windowed);
    for (var i = 0; i < _windowLength / 2; i++) {
      final tmpPower = (fft[i] * fft[i].conjugate).real / _windowLength;
      spectrum[i] = -(10 * log10(tmpPower));
    }
    notifyListeners();
  }

  void handleError(PlatformException error) {
    isRecording = false;
    print(error.message);
    print(error.details);
  }

  Future<void> start() async {
    try {
      await _streamer.start(onAudio, handleError);
      isRecording = true;
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> stop() async {
    final stopped = await _streamer.stop();
    isRecording = stopped;
    notifyListeners();
  }

  // List<int> samples;
  // List<double> power;
  // bool isRecording = false;

  // StreamSubscription _recorderStatus;
  // StreamSubscription _playerStatus;
  // StreamSubscription _audioStream;

  // @override
  // void dispose() {
  //   _recorderStatus?.cancel();
  //   _playerStatus?.cancel();
  //   _audioStream?.cancel();
  //   super.dispose();
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlugin() async {
  //   _recorderStatus = _recorder.status.listen(
  //     (status) {
  //       isRecording = status == SoundStreamStatus.Playing;
  //     },
  //   );

  //   /// ここでデータを取ってきている。
  //   _audioStream = _recorder.audioStream.listen(
  //     (data) {
  //       // この変換方法で正しいのか調査が必要
  //       samples = List.filled(pow(2, 13).toInt(), 0);
  //       power = List.filled(pow(2, 13).toInt(), 0);

  //       // TODO: 波形データが取れない！
  //       for (var i = 0; i < Uint16List.view(data.buffer).length; i++) {
  //         samples[i] = Uint16List.view(data.buffer)[i];
  //       }
  //       print(samples);
  //       final window = Window(WindowType.HANN);
  //       final windowed = window.apply(samples);
  //       final fft = FFT().Transform(windowed);
  //       for (var i = 0; i < pow(2, 13).toInt(); i++) {
  //         final tmpPower = (fft[i] * fft[i].conjugate).real;
  //         // power[i] = -(10 * log10(tmpPower));
  //         power[i] = -tmpPower.toDouble();
  //       }
  //       notifyListeners();
  //     },
  //   );

  //   /// 初期化
  //   await Future.wait<void>(
  //     [
  //       _recorder.initialize(),
  //       _player.initialize(),
  //     ],
  //   );
  // }

  // Future<void> startRecorder() async {
  //   await _recorder.start();
  //   notifyListeners();
  // }

  // Future<void> stopRecorder() async {
  //   await _recorder.stop();
  //   notifyListeners();
  // }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final RecorderStream _recorder = RecorderStream();
//   final PlayerStream _player = PlayerStream();

//   final List<Uint8List> _micChunks = [];
//   Uint8List _samples;
//   bool _isRecording = false;
//   bool _isPlaying = false;

//   StreamSubscription _recorderStatus;
//   StreamSubscription _playerStatus;
//   StreamSubscription _audioStream;

//   @override
//   void initState() {
//     super.initState();
//     initPlugin();
//   }

//   @override
//   void dispose() {
//     _recorderStatus?.cancel();
//     _playerStatus?.cancel();
//     _audioStream?.cancel();
//     super.dispose();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlugin() async {
//     _recorderStatus = _recorder.status.listen((status) {
//       if (mounted) {
//         setState(() {
//           _isRecording = status == SoundStreamStatus.Playing;
//         });
//       }
//     });

//     /// ここでデータを取ってきている。
//     _audioStream = _recorder.audioStream.listen((data) {
//       _samples = data;
//       if (_isPlaying) {
//         _player.writeChunk(data);
//       } else {
//         _micChunks.add(data);
//       }
//     });

//     _playerStatus = _player.status.listen((status) {
//       if (mounted) {
//         setState(() {
//           _isPlaying = status == SoundStreamStatus.Playing;
//         });
//       }
//     });

//     await Future.wait<void>([
//       _recorder.initialize(),
//       _player.initialize(),
//     ]);
//   }

//   // ignore: avoid_void_async
//   void _play() async {
//     await _player.start();

//     if (_micChunks.isNotEmpty) {
//       for (final chunk in _micChunks) {
//         await _player.writeChunk(chunk);
//         print(chunk);
//       }
//       _micChunks.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   iconSize: 96,
//                   icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
//                   onPressed: _isRecording ? _recorder.stop : _recorder.start,
//                 ),
//                 IconButton(
//                   iconSize: 96,
//                   icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                   onPressed: _isPlaying ? _player.stop : _play,
//                 ),
//               ],
//             ),
//             Text(_samples.toString()),
//           ],
//         ),
//       ),
//     );
//   }
// }
