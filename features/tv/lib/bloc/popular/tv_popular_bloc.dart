import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/popular/tv_popular_event.dart';
import 'package:tv/bloc/popular/tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTvSeries _getPopularTvSeries;

  TvPopularBloc({
    required GetPopularTvSeries getPopularTvSeries,
  })  : _getPopularTvSeries = getPopularTvSeries,
        super(TvPopularEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(TvPopularLoading());
      final result = await _getPopularTvSeries.execute();

      result.fold(
        (failure) => emit(TvPopularError(failure.message)),
        (data) => emit(TvPopularHasData(popular: data)),
      );
    });
  }
}