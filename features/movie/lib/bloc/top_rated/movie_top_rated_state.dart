import 'package:equatable/equatable.dart';
import 'package:model/movie/movie.dart';

abstract class MovieTopRatedState extends Equatable {
  const MovieTopRatedState();

  @override
  List<Object> get props => [];
}

class MovieTopRatedEmpty extends MovieTopRatedState {}

class MovieTopRatedLoading extends MovieTopRatedState {}

class MovieTopRatedError extends MovieTopRatedState {
  final String message;

  const MovieTopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieTopRatedHasData extends MovieTopRatedState {
  final List<Movie> topRated;

  const MovieTopRatedHasData({required this.topRated});

  @override
  List<Object> get props => [topRated];
}