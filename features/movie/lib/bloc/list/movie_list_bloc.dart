import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  MovieListBloc({
    required GetNowPlayingMovies getNowPlayingMovies,
    required GetPopularMovies getPopularMovies,
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        _getPopularMovies = getPopularMovies,
        _getTopRatedMovies = getTopRatedMovies,
        super(MovieListEmpty()) {
    on<FetchMovieList>((event, emit) async {
      emit(MovieListLoading());
      final resultNowPlaying = await _getNowPlayingMovies.execute();
      final resultPopular = await _getPopularMovies.execute();
      final resultTopRated = await _getTopRatedMovies.execute();

      resultNowPlaying.fold(
        (failure) => emit(MovieListError(failure.message)),
        (dataNowPlaying) async {
          resultPopular.fold(
              (failurePopular) => emit(MovieListError(failurePopular.message)),
              (dataPopular) {
            resultTopRated.fold(
              (failureTopRated) =>
                  emit(MovieListError(failureTopRated.message)),
              (dataTopRated) => emit(
                MovieListHasData(
                  nowPlaying: dataNowPlaying,
                  popular: dataPopular,
                  topRated: dataTopRated,
                ),
              ),
            );
          });
        },
      );
    });
  }
}
