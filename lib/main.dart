import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

/// Entry point for the Pokémon Route Music application.
///
/// This app listens to the device's location in real time and
/// performs a simple reverse‑geocode lookup on each position update.
/// When the user moves onto a new street/route, the associated piece
/// of music is played. The mapping of route names to audio assets is
/// defined in [routeAudio].  You can expand or modify this map to
/// include additional routes and songs.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AudioPlayer _audioPlayer;
  StreamSubscription<Position>? _positionStream;
  String _currentRoute = '';
  String _status = 'Requesting permissions…';

  /// A mapping of route names to audio asset paths.  If the current route
  /// isn't present, the first value in this map will be used as a fallback.
  final Map<String, String> routeAudio = {
    'Route 1': 'assets/audio/route_1.wav',
    'Route 2': 'assets/audio/route_2.wav',
  };

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initLocation();
  }

  /// Requests location permission and starts listening for position changes
  /// once granted.
  Future<void> _initLocation() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      setState(() {
        _status = 'Listening for location updates…';
      });
      final stream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 20, // update when user moves 20 metres
        ),
      );
      _positionStream = stream.listen(_processPosition);
    } else {
      setState(() {
        _status = 'Location permission denied';
      });
    }
  }

  /// Processes each position update by reverse geocoding the coordinates.
  /// If the street name has changed, a new piece of music is selected
  /// and played.
  Future<void> _processPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final routeName = placemarks.first.street ?? '';
        if (routeName.isNotEmpty && routeName != _currentRoute) {
          _currentRoute = routeName;
          setState(() {
            _status = 'Now on $_currentRoute';
          });
          await _playMusicForRoute(_currentRoute);
        }
      }
    } catch (e) {
      // In case reverse geocoding fails, just log the error silently.
    }
  }

  /// Plays the audio associated with the given route name.  Stops any
  /// existing playback before starting the new track.  If the route is
  /// unmapped, a fallback track is chosen.
  Future<void> _playMusicForRoute(String routeName) async {
    final String asset = routeAudio[routeName] ?? routeAudio.values.first;
    await _audioPlayer.stop();
    // The AssetSource constructor tells audioplayers to look for this
    // file in your project's asset bundle.
    await _audioPlayer.play(AssetSource(asset));
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Route Music',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pokémon Route Music'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.music_note, size: 72.0),
                const SizedBox(height: 16),
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                Text(
                  'Move around to different streets to hear different tracks!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
