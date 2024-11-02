import 'package:domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:domain/usecases/tv/get_popular_tv_series.dart';
import 'package:domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/list/tv_list_event.dart';
import 'package:tv/bloc/list/tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvSeries _getNowPlayingTvSeries;
  final GetPopularTvSeries _getPopularTvSeries;
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TvListBloc({
    required GetNowPlayingTvSeries getNowPlayingTvSeries,
    required GetPopularTvSeries getPopularTvSeries,
    required GetTopRatedTvSeries getTopRatedTvSeries,
  })  : _getNowPlayingTvSeries = getNowPlayingTvSeries,
        _getPopularTvSeries = getPopularTvSeries,
        _getTopRatedTvSeries = getTopRatedTvSeries,
        super(TvListEmpty()) {
    on<FetchTvList>((event, emit) async {
      emit(TvListLoading());
      final resultNowPlaying = await _getNowPlayingTvSeries.execute();
      final resultPopular = await _getPopularTvSeries.execute();
      final resultTopRated = await _getTopRatedTvSeries.execute();

      resultNowPlaying.fold(
        (failure) => emit(TvListError(failure.message)),
        (dataNowPlaying) async {
          resultPopular.fold(
              (failurePopular) => emit(TvListError(failurePopular.message)),
              (dataPopular) {
            resultTopRated.fold(
              (failureTopRated) =>
                  emit(TvListError(failureTopRated.message)),
              (dataTopRated) => emit(
                TvListHasData(
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
