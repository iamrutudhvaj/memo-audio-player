import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart' as AW;
import 'package:bloc/bloc.dart';
import 'package:memo/player/bloc/player_events.dart';
import 'package:memo/player/bloc/player_states.dart';
import 'package:memo/service/network/http_client.dart';

/// The PlayerBloc handles audio player events such as downloading,
/// playing, pausing, and updating the audio's current duration.
/// It interacts with the audio player controller to manage audio playback
/// and emits states based on the player's status.
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  /// Constructor initializing the PlayerBloc with the initial state.
  PlayerBloc() : super(const AudioInitial(Duration.zero)) {
    // Register event handlers
    on<DownloadAudio>(_onDownloadAudio);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<UpdateAudioTime>(_onUpdateAudioTime);
  }

  /// An instance of the Audio Waveforms PlayerController used to manage audio playback.
  final AW.PlayerController playerController = AW.PlayerController();

  /// A variable to track the current playback duration of the audio.
  Duration currentDuration = const Duration(minutes: 0);

  /// Handles the `UpdateAudioTime` event.
  /// Emits the updated player state (either playing or paused) with the current duration.
  Future<void> _onUpdateAudioTime(
      UpdateAudioTime event, Emitter<PlayerState> emit) async {
    // Emit the appropriate state based on whether the audio is playing or paused.
    if (state is AudioPlaying) {
      emit(AudioPlaying(currentDuration));
    } else if (state is AudioPaused) {
      emit(AudioPaused(currentDuration));
    }
  }

  /// Handles the `PlayAudio` event.
  /// Starts the player and emits the `AudioPlaying` state with the current duration.
  Future<void> _onPlayAudio(PlayAudio event, Emitter<PlayerState> emit) async {
    playerController.startPlayer();
    emit(AudioPlaying(currentDuration));
  }

  /// Handles the `PauseAudio` event.
  /// Pauses the player and emits the `AudioPaused` state with the current duration.
  Future<void> _onPauseAudio(
      PauseAudio event, Emitter<PlayerState> emit) async {
    playerController.pausePlayer();
    emit(AudioPaused(currentDuration));
  }

  /// Handles the `DownloadAudio` event.
  /// Downloads the audio file from a given URL, emits loading and downloaded states,
  /// and sets up the player controller to play the downloaded file.
  Future<void> _onDownloadAudio(
      DownloadAudio event, Emitter<PlayerState> emit) async {
    // Emit loading state while downloading the audio.
    emit(const AudioLoading(Duration.zero));
    try {
      // Attempt to download the audio file.
      final filePath = await _downloadAudio();
      emit(AudioDownloaded(Duration.zero, filePath));

      // Set up the player controller with the downloaded file.
      setupPlayerController(filePath, emit);
    } catch (e) {
      // If an error occurs, emit an error state with the error message.
      emit(AudioError(Duration.zero, e.toString()));
    }
  }

  /// Configures the player controller with the downloaded audio file.
  /// Sets up event listeners for the audio duration changes.
  ///
  /// [filePath] The path to the downloaded audio file.
  /// [emit] The emitter to send updated states to the UI.
  Future<void> setupPlayerController(
      String filePath, Emitter<PlayerState> emit) async {
    // Prepare the player with the given file path.
    playerController.preparePlayer(path: filePath);

    // Set the player to loop when finished.
    playerController.setFinishMode(finishMode: AW.FinishMode.loop);

    // Listen for changes in the current playback duration and update the state.
    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = Duration(milliseconds: event);
      add(UpdateAudioTime());
    });
  }

  /// Downloads the audio file from the provided URL.
  ///
  /// [Returns] The path to the downloaded audio file.
  /// Throws errors for timeout or network-related issues.
  Future<String> _downloadAudio() async {
    const url =
        'https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3';
    try {
      // Create a custom HTTP client and download the audio file.
      CustomHttpClient client = CustomHttpClient();
      return await client.downloadFile(url);
    } on TimeoutException {
      // Handle timeout exceptions.
      throw Exception('Request timed out');
    } on SocketException {
      // Handle network issues such as no internet connection.
      throw Exception('Network issue, check your connection');
    }
  }
}
