import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_event.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_state.dart';

class TvDetailWatchlistBloc extends Bloc<TvDetailWatchlistEvent, TvDetailWatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  static const watchlistErrorMessage = 'Failed to do action';

  final GetTvWatchlistStatus _getTvWatchlistStatus;
  final SaveTvWatchlist _saveTvWatchlist;
  final RemoveTvWatchlist _removeTvWatchlist;

  TvDetailWatchlistBloc({
    required GetTvWatchlistStatus getWatchlistStatus,
    required SaveTvWatchlist saveWatchlist,
    required RemoveTvWatchlist removeWatchlist,
  })  : _getTvWatchlistStatus = getWatchlistStatus,
        _saveTvWatchlist = saveWatchlist,
        _removeTvWatchlist = removeWatchlist,
        super(NotOnWatchlist()) {
    on<AddToWatchlist>((event, emit) async {
      emit(UpdatingWatchlist());

      final result = await _saveTvWatchlist.execute(event.tvDetail);
      result.fold((failure) => emit(WatchlistError(failure.message)),
          (_) => emit(AlreadyOnWatchlist()));
    });

    on<CheckWatchlistStatus>((event, emit) async {
      final result = await _getTvWatchlistStatus.execute(event.id);
      if (result) {
        emit(AlreadyOnWatchlist());
      } else {
        emit(NotOnWatchlist());
      }
    });

    on<RemoveWatchlist>((event, emit) async {
      emit(UpdatingWatchlist());

      final result = await _removeTvWatchlist.execute(event.tvDetail);
      result.fold((failure) => emit(WatchlistError(failure.message)),
          (_) => emit(NotOnWatchlist()));
    });
  }
}
