import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool autoPlay = true;
  bool vibrateOnChange = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text('Autoplay'),
            subtitle:
                const Text('Automatically play music when route changes'),
            value: autoPlay,
            onChanged: (bool value) {
              setState(() {
                autoPlay = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Vibrate on change'),
            subtitle:
                const Text('Vibrate the device when the route changes'),
            value: vibrateOnChange,
            onChanged: (bool value) {
              setState(() {
                vibrateOnChange = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Note: These settings are for demonstration purposes only.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
