import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status = 'Requesting permissions…';
  String _currentRoute = '';
  late final AudioPlayer _audioPlayer;
  StreamSubscription<Position>? _positionStream;

  /// Mapping of route names to audio asset paths.
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

  Future<void> _initLocation() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      setState(() {
        _status = 'Listening for location updates…';
      });
      final stream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 20,
        ),
      );
      _positionStream = stream.listen(_processPosition);
    } else {
      setState(() {
        _status = 'Location permission denied';
      });
    }
  }

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
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> _playMusicForRoute(String routeName) async {
    final asset = routeAudio[routeName] ?? routeAudio.values.first;
    await _audioPlayer.stop();
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
    return Padding(
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
          const Text(
            'Move around to different streets to hear different tracks!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
