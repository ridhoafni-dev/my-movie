import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_bloc.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_event.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_state.dart';
import 'package:utils/utils/failure.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRated;

  late TvTopRatedBloc tvTopRatedBloc;

  setUp(() {
    mockGetTopRated = MockGetTopRatedTvSeries();
    tvTopRatedBloc = TvTopRatedBloc(getTopRatedTvSeries: mockGetTopRated);
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

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetTopRated.execute()).thenAnswer((_) async => Right(tTvList));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TvTopRatedLoading(),
      TvTopRatedHasData(topRated: tTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRated.execute());
    },
  );

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockGetTopRated.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TvTopRatedLoading(),
      const TvTopRatedError('fail'),
    ],
    verify: (bloc) {
      verify(mockGetTopRated.execute());
    },
  );
}
