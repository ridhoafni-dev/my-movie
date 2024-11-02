import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_event.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TvTopRatedBloc({
    required GetTopRatedTvSeries getTopRatedTvSeries,
  })  : _getTopRatedTvSeries = getTopRatedTvSeries,
        super(TvTopRatedEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TvTopRatedLoading());
      final result = await _getTopRatedTvSeries.execute();

      result.fold(
        (failure) => emit(TvTopRatedError(failure.message)),
        (data) => emit(TvTopRatedHasData(topRated: data)),
      );
    });
  }
}