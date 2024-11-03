import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/get_tv_detail.dart';
import 'package:domain/usecases/tv/get_tv_recommendations.dart';
import 'package:dummy_data/dummy_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';
import 'package:tv/bloc/detail/tv_detail_bloc.dart';
import 'package:tv/bloc/detail/tv_detail_event.dart';
import 'package:tv/bloc/detail/tv_detail_state.dart';
import 'package:utils/utils/failure.dart';

import 'tv_detail_bloc_test.mocks.dart';
@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();

    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
    );
  });

  const tId = 1;

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeries = <Tv>[tTv];

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvSeries));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(tId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(tv: testTvDetail, recommendations: tTvSeries),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    "Should emit [Loading, Error] when get fetch is failed",
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(tId)),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('error'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );
}
