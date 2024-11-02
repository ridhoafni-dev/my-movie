import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_event.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  TvWatchlistBloc({required this.getWatchlistTvSeries}) : super(TvWatchlistLoading()) {
    on<LoadWatchlistTvSeries>((event, emit) async {
      emit(TvWatchlistLoading());

      final result = await getWatchlistTvSeries.execute();

      result.fold(
        (failure) => emit(TvWatchlistError(failure.message)),
        (data) => emit(TvWatchlistHasData(data)),
      );
    });
  }

}