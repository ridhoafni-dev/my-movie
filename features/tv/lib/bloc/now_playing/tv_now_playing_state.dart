import 'package:equatable/equatable.dart';
import 'package:model/tv/tv.dart';

abstract class TvNowPlayingState extends Equatable {
  const TvNowPlayingState();

  @override
  List<Object> get props => [];
}

class TvNowPlayingEmpty extends TvNowPlayingState {}

class TvNowPlayingLoading extends TvNowPlayingState {}

class TvNowPlayingError extends TvNowPlayingState {
  final String message;

  const TvNowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class TvNowPlayingHasData extends TvNowPlayingState {
  final List<Tv> nowPlaying;

  const TvNowPlayingHasData({required this.nowPlaying});

  @override
  List<Object> get props => [nowPlaying];
}