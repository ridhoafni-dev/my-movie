import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_event.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_state.dart';

class MovieDetailWatchlistBloc extends Bloc<MovieDetailWatchlistEvent, MovieDetailWatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  static const watchlistErrorMessage = 'Failed to do action';

  final GetMovieWatchListStatus _getMovieWatchListStatus;
  final SaveMovieWatchlist _saveMovieWatchlist;
  final RemoveMovieWatchlist _removeMovieWatchlist;

  MovieDetailWatchlistBloc({
    required GetMovieWatchListStatus getWatchlistStatus,
    required SaveMovieWatchlist saveWatchlist,
    required RemoveMovieWatchlist removeWatchlist,
  })  : _getMovieWatchListStatus = getWatchlistStatus,
        _saveMovieWatchlist = saveWatchlist,
        _removeMovieWatchlist = removeWatchlist,
        super(NotOnWatchlist()) {
      on<AddToWatchlist>((event, emit) async {
      emit(UpdatingWatchlist());

      final result = await _saveMovieWatchlist.execute(event.movieDetail);
      result.fold((failure) => emit(WatchlistError(failure.message)),
          (_) => emit(AlreadyOnWatchlist()));
    });

    on<CheckWatchlistStatus>((event, emit) async {
      final result = await _getMovieWatchListStatus.execute(event.id);
      if (result) {
        emit(AlreadyOnWatchlist());
      } else {
        emit(NotOnWatchlist());
      }
    });

    on<RemoveWatchlist>((event, emit) async {
      emit(UpdatingWatchlist());

      final result = await _removeMovieWatchlist.execute(event.movieDetail);
      result.fold((failure) => emit(WatchlistError(failure.message)),
          (_) => emit(NotOnWatchlist()));
    });
  }
}
