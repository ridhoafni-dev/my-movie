import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/detail/tv_detail_event.dart';
import 'package:tv/bloc/detail/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;
  final GetTvRecommendations _getTvRecommendations;

  TvDetailBloc({
    required GetTvDetail getTvDetail,
    required GetTvRecommendations getTvRecommendations,
  })  : _getTvDetail = getTvDetail,
        _getTvRecommendations = getTvRecommendations,
        super(TvDetailEmpty()) {
    on<FetchTvDetail>((event, emit) async {
      emit(TvDetailLoading());
      final resultDetail = await _getTvDetail.execute(event.id);
      final resultRecommendations = await _getTvRecommendations.execute(event.id);

      resultDetail.fold(
        (failure) => emit(TvDetailError(failure.message)),
        (dataDetail) async {
          resultRecommendations.fold(
              (failureRecommendations) => emit(TvDetailError(failureRecommendations.message)),
              (dataRecommendations) => emit(
                TvDetailHasData(
                  tv: dataDetail,
                  recommendations: dataRecommendations,
                ),
              ),
          );
        },
      );
    });
  }
}

