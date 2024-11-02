import 'package:equatable/equatable.dart';

abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistMovies extends MovieWatchlistEvent {}
