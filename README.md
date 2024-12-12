# Memo Audio Player App

A Flutter app that plays audio files, with functionality to download, play, pause, and visualize the audio waveform. This app uses `flutter_bloc` for state management and custom HTTP client handling for downloading audio files.

## Features
- Download audio from a remote URL.
- Play and pause the audio.
- Visualize audio waveforms.
- Display current playback duration.
- Error handling for download and playback issues.

## Tech Stack
- **Flutter**: Cross-platform app development framework.
- **flutter_bloc**: State management solution using the BLoC pattern.
- **audio_waveforms**: Package for displaying audio waveforms.
- **Google Fonts**: For custom fonts.
- **http**: HTTP package for making network requests.

## Project Structure
- **`lib/main.dart`**: Entry point of the app. Initializes the `PlayerBloc` and loads the `PlayerPage`.
- **`lib/player/bloc/player_bloc.dart`**: Contains the `PlayerBloc` class which manages events for playing, pausing, and downloading audio.
- **`lib/player/bloc/player_events.dart`**: Defines events for downloading, playing, pausing, and updating the audio time.
- **`lib/player/bloc/player_state.dart`**: Defines the various states for the audio player (loading, playing, paused, etc.).
- **`lib/player/player_page.dart`**: UI for the audio player, with play/pause functionality and audio waveform display.
- **`lib/service/network/http_client.dart`**: Custom HTTP client to handle downloading audio files and making GET/POST requests with error handling.

## Getting Started

### Prerequisites
Ensure that you have Flutter installed on your machine. If not, follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### Installation

1. Clone this repository:
    ```bash
    git clone https://github.com/iamrutudhvaj/memo-audio-player.git
    ```

2. Navigate to the project directory:
    ```bash
    cd memo-audio-player
    ```

3. Install the dependencies:
    ```bash
    flutter pub get
    ```

4. Run the app:
    ```bash
    flutter run
    ```

## Usage

- When the app starts, it will automatically download the audio file and display the playback controls.
- The UI shows a waveform of the audio, and you can play or pause it by tapping the play/pause button.
- The current playback time is displayed in `MM:SS` format.
- In case of any error (e.g., network issues or file download failure), an error message will be displayed.

## Error Handling

The app includes error handling for:
- Timeout exceptions during file download.
- Network issues (no internet connection).
- Audio playback errors.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-name`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flutter](https://flutter.dev) for the cross-platform framework.
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) for state management.
- [audio_waveforms](https://pub.dev/packages/audio_waveforms) for waveform visualization.
- [Google Fonts](https://pub.dev/packages/google_fonts) for custom fonts.
