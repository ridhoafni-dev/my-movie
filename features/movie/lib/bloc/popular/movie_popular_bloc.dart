import 'package:domain/usecases/movie/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_popular_event.dart';
import 'movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies _getPopularMovies;

  MoviePopularBloc({
    required GetPopularMovies getPopularMovies,
  })  : _getPopularMovies = getPopularMovies,
        super(MoviePopularEmpty()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(MoviePopularLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) => emit(MoviePopularError(failure.message)),
        (data) => emit(MoviePopularHasData(popular: data)),
      );
    });
  }
}