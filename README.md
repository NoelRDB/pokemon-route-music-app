# pokemon-route-music-app

This repository contains a simple cross-platform mobile application built with Flutter that plays Pokémon game music based on GPS location changes between routes. When you travel from one street to another the app detects the change and automatically plays the corresponding background music. It is designed as a fun proof-of-concept and is open source so that anyone can extend it with additional tracks and features.

## Features

- **Real-time GPS detection** – The app monitors your location using the device’s GPS and determines when you move between different roads or avenues.
- **Audio playback** – A different audio file is played for each route, simulating the way music changes in Pokémon games when you enter a new area.
- **Cross-platform** – Built with Flutter so it runs on both Android and iOS.
- **Extendable** – You can easily add more tracks or change the route mappings by editing a simple map in `lib/main.dart`.

## Getting started

These instructions will help you set up the application on your local machine for development and testing purposes.

### Prerequisites

You need to have the following installed:

- Flutter SDK (version 3.0 or higher). You can download it from the [official Flutter website](https://flutter.dev/docs/get-started/install).
- Android Studio or Xcode (for building and running on Android/iOS).
- A device or simulator/emulator with GPS capabilities.

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/NoelRDB/pokemon-route-music-app.git
   cd pokemon-route-music-app
   ```

2. **Install dependencies**

   Run the following command to install the required Flutter packages:

   ```bash
   flutter pub get
   ```

3. **Add audio tracks**

   The `assets/audio` directory contains placeholder files. Replace these with your own Pokémon music tracks. Update `pubspec.yaml` if you add additional files so that Flutter packages them.

4. **Run the app**

   Connect your device or start an emulator, then run:

   ```bash
   flutter run
   ```

   The app will request location permissions and then start monitoring your position. When you move between routes (based on geocoded street names), it will change the music.

### Permissions

This app requires location permissions. Make sure you grant GPS access when prompted. On Android you may also need to enable location in the background for continuous updates.

### Notes

- This project uses simple string matching on street names to decide when to change music. Depending on your locale or the way addresses are formatted, you might need to adjust the logic in `lib/main.dart`.
- The audio files included in this repository are placeholders and may not match any specific Pokémon route. Feel free to replace them with official game tracks or your own choices.

## Contributing

Contributions are welcome! If you’d like to add features such as:

- A nicer UI.
- Map-based visualization.
- More sophisticated route parsing.
- An in-app database of Pokémon tracks with search and download.

Feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
