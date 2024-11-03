import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:domain/usecases/tv/save_tv_watchlist.dart';
import 'package:dummy_data/dummy_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_bloc.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_event.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_state.dart';
import 'package:utils/utils/failure.dart';

import 'tv_detail_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetTvWatchlistStatus, SaveTvWatchlist, RemoveTvWatchlist])
void main() {
  late MockGetTvWatchlistStatus mockGetWatchListStatus;
  late MockSaveTvWatchlist mockSaveWatchlist;
  late MockRemoveTvWatchlist mockRemoveWatchlist;

  late TvDetailWatchlistBloc tvDetailWatchlistBloc;

  setUp(() {
    mockGetWatchListStatus = MockGetTvWatchlistStatus();
    mockSaveWatchlist = MockSaveTvWatchlist();
    mockRemoveWatchlist = MockRemoveTvWatchlist();

    tvDetailWatchlistBloc = TvDetailWatchlistBloc(
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchlistStatus: mockGetWatchListStatus,
    );
  });

  const tId = 1;

  blocTest<TvDetailWatchlistBloc, TvDetailWatchlistState>(
    'Should emit [AlreadyOnWatchlist] when get add is success',
    build: () {
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('success'));
      return tvDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddToWatchlist(testTvDetail)),
    expect: () => [
      UpdatingWatchlist(),
      AlreadyOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvDetailWatchlistBloc, TvDetailWatchlistState>(
    'Should emit [WatchlistError] when get add is failed',
    build: () {
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('fail')));
      return tvDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddToWatchlist(testTvDetail)),
    expect: () => [
      UpdatingWatchlist(),
      const WatchlistError('fail'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvDetailWatchlistBloc, TvDetailWatchlistState>(
    'Should emit [NotOnWatchlist] when get remove is success',
    build: () {
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('success'));
      return tvDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlist(testTvDetail)),
    expect: () => [
      UpdatingWatchlist(),
      NotOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvDetailWatchlistBloc, TvDetailWatchlistState>(
    'Should emit [WatchlistError] when get remove is failed',
    build: () {
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('fail')));
      return tvDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlist(testTvDetail)),
    expect: () => [
      UpdatingWatchlist(),
      const WatchlistError('fail'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testTvDetail));
    },
  );

  blocTest<TvDetailWatchlistBloc, TvDetailWatchlistState>(
    'Should emit [AlreadyOnWatchList] when get status returning true',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return tvDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const CheckWatchlistStatus(tId)),
    expect: () => [
      AlreadyOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<TvDetailWatchlistBloc, TvDetailWatchlistState>(
    'Should emit [NotOnWatchlist] when get status returning false',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return tvDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const CheckWatchlistStatus(tId)),
    expect: () => [
      NotOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );
}
