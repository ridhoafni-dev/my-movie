import 'package:domain/usecases/movie/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_top_rated_event.dart';
import 'movie_top_rated_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies _getTopRatedMovies;

  MovieTopRatedBloc({
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getTopRatedMovies = getTopRatedMovies,
        super(MovieTopRatedEmpty()) {
    on<FetchTopRatedMovie>((event, emit) async {
      emit(MovieTopRatedLoading());
      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) => emit(MovieTopRatedError(failure.message)),
        (data) => emit(MovieTopRatedHasData(topRated: data)),
      );
    });
  }
}