import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_watchlist_event.dart';
import 'movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;

  MovieWatchlistBloc({required GetWatchlistMovies getWatchlistMovies}) : _getWatchlistMovies = getWatchlistMovies, super(MovieWatchlistEmpty()) {
    on<LoadWatchlistMovies>((event, emit) async {
      emit(MovieWatchlistLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(MovieWatchlistError(failure.message)),
        (data) => emit(MovieWatchlistHasData(watchlist: data)),
      );
    });
  }


}