import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

/// This event is for Download audio
class DownloadAudio extends PlayerEvent {}

/// This event is for Play audio
class PlayAudio extends PlayerEvent {}

/// This event is for Pause audio
class PauseAudio extends PlayerEvent {}

/// This event is for Update Audio Time
class UpdateAudioTime extends PlayerEvent {}
