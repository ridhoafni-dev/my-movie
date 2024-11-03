import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';
import 'package:search/bloc/tv/tv_search_bloc.dart';
import 'package:search/bloc/tv/tv_search_event.dart';
import 'package:search/bloc/tv/tv_search_state.dart';
import 'package:utils/utils/failure.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late MockSearchTvSeries mockSearchTvSeries;

  late TvSearchBloc tvSearchBloc;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSearchBloc = TvSearchBloc(searchTvSeries: mockSearchTvSeries);
  });

  final tTvModel = Tv(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvList = <Tv>[tTvModel];
  const tQuery = 'spiderman';

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const SearchTvProgram(tQuery)),
    expect: () => [
      TvSearchLoading(),
      TvSearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const SearchTvProgram(tQuery)),
    expect: () => [
      TvSearchLoading(),
      const TvSearchError('fail'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
