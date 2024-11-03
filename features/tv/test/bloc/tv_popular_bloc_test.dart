import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';
import 'package:tv/bloc/popular/tv_popular_bloc.dart';
import 'package:tv/bloc/popular/tv_popular_event.dart';
import 'package:tv/bloc/popular/tv_popular_state.dart';
import 'package:utils/utils/failure.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvs;

  late TvPopularBloc tvPopularBloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvSeries();
    tvPopularBloc = TvPopularBloc(getPopularTvSeries: mockGetPopularTvs);
  });


  final tTvSeries = Tv(
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
  final tTvList = <Tv>[tTvSeries];

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [
      TvPopularLoading(),
      TvPopularHasData(popular: tTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [
      TvPopularLoading(),
      const TvPopularError('fail'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
