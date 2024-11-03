import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:utils/utils/failure.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_bloc.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_event.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_state.dart';

import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  late TvWatchlistBloc tvWatchlistBloc;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    tvWatchlistBloc = TvWatchlistBloc(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading,HasData] when get fetch is success',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTvSeries()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistHasData([testWatchlistTv]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => const Left(DatabaseFailure('fail')));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistTvSeries()),
    expect: () => [
      TvWatchlistLoading(),
      const TvWatchlistError('fail'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );
}
