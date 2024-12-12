import 'package:equatable/equatable.dart';

abstract class PlayerState extends Equatable {
  final Duration duration;
  const PlayerState(this.duration);

  @override
  List<Object?> get props => [duration];
}

class AudioInitial extends PlayerState {
  const AudioInitial(super.duration);
}

class AudioLoading extends PlayerState {
  const AudioLoading(super.duration);
}

class AudioDownloaded extends PlayerState {
  final String filePath;

  const AudioDownloaded(super.duration, this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class AudioPlaying extends PlayerState {
  const AudioPlaying(super.duration);

  @override
  List<Object?> get props => [duration];
}

class AudioPaused extends PlayerState {
  const AudioPaused(super.duration);

  @override
  List<Object?> get props => [duration];
}

class AudioError extends PlayerState {
  final String message;

  const AudioError(super.duration, this.message);

  @override
  List<Object?> get props => [message];
}
