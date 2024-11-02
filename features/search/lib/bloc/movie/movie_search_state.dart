import 'package:equatable/equatable.dart';
import 'package:model/movie/movie.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

class MovieSearchEmpty extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchError extends MovieSearchState {
  final String message;

  const MovieSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieSearchHasData extends MovieSearchState {
  final List<Movie> searchResult;

  const MovieSearchHasData(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}
