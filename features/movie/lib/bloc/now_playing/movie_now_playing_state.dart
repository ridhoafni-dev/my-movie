import 'package:equatable/equatable.dart';
import 'package:model/movie/movie.dart';

abstract class MovieNowPlayingState extends Equatable {
  const MovieNowPlayingState();

  @override
  List<Object> get props => [];
}

class MovieNowPlayingEmpty extends MovieNowPlayingState {}

class MovieNowPlayingLoading extends MovieNowPlayingState {}

class MovieNowPlayingError extends MovieNowPlayingState {
  final String message;

  const MovieNowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieNowPlayingHasData extends MovieNowPlayingState {
  final List<Movie> nowPlaying;

  const MovieNowPlayingHasData({required this.nowPlaying});

  @override
  List<Object> get props => [nowPlaying];
}