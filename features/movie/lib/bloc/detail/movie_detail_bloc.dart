import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/detail/movie_detail_event.dart';
import 'package:movie/bloc/detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;

  MovieDetailBloc({
    required GetMovieDetail getMovieDetail,
    required GetMovieRecommendations getMovieRecommendations,
  })  : _getMovieDetail = getMovieDetail,
        _getMovieRecommendations = getMovieRecommendations,
        super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      final resultDetail = await _getMovieDetail.execute(event.id);
      final resultRecommendations = await _getMovieRecommendations.execute(event.id);

      resultDetail.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (dataDetail) async {
          resultRecommendations.fold(
              (failureRecommendations) => emit(MovieDetailError(failureRecommendations.message)),
              (dataRecommendations) => emit(
                MovieDetailHasData(
                  movie: dataDetail,
                  recommendations: dataRecommendations,
                ),
              ),
          );
        },
      );
    });
  }
}

