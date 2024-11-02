import 'package:domain/usecases/movie/get_now_playing_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_now_playing_event.dart';
import 'movie_now_playing_state.dart';

class MovieNowPlayingBloc
    extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieNowPlayingBloc({
    required GetNowPlayingMovies getNowPlayingMovies,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        super(MovieNowPlayingEmpty()) {
    on<FetchNowPlayingMovie>((event, emit) async {
      emit(MovieNowPlayingLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) => emit(MovieNowPlayingError(failure.message)),
        (data) => emit(MovieNowPlayingHasData(nowPlaying: data)),
      );
    });
  }
}
