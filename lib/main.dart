import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sound_stream/sound_stream.dart';
import 'start_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 縦方向に画面固定
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.amberAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          shape: RoundedRectangleBorder(
            // Dialog以外のボタンの角に影響を与えることができる
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: StartPage(),
    );
  }
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
