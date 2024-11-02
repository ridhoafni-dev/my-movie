import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/now_playing/tv_now_playing_event.dart';
import 'package:tv/bloc/now_playing/tv_now_playing_state.dart';

class TvNowPlayingBloc
    extends Bloc<TvNowPlayingEvent, TvNowPlayingState> {
  final GetNowPlayingTvSeries _getNowPlayingTvSeries;

  TvNowPlayingBloc({
    required GetNowPlayingTvSeries getNowPlayingTvSeries,
  })  : _getNowPlayingTvSeries = getNowPlayingTvSeries,
        super(TvNowPlayingEmpty()) {
    on<FetchNowPlayingTv>((event, emit) async {
      emit(TvNowPlayingLoading());
      final result = await _getNowPlayingTvSeries.execute();

      result.fold(
        (failure) => emit(TvNowPlayingError(failure.message)),
        (data) => emit(TvNowPlayingHasData(nowPlaying: data)),
      );
    });
  }
}
