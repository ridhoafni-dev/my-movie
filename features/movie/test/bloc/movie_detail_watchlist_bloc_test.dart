import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_movie_watchlist_status.dart';
import 'package:domain/usecases/movie/remove_movie_watchlist.dart';
import 'package:domain/usecases/movie/save_movie_watchlist.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_bloc.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_event.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_state.dart';
import 'package:utils/utils/failure.dart';

import 'movie_detail_watchlist_bloc_test.mocks.dart';

@GenerateMocks(
    [GetMovieWatchListStatus, SaveMovieWatchlist, RemoveMovieWatchlist])
void main() {
  late MockGetMovieWatchListStatus mockGetWatchListStatus;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;

  late MovieDetailWatchlistBloc movieDetailWatchlistBloc;

  setUp(() {
    mockGetWatchListStatus = MockGetMovieWatchListStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();

    movieDetailWatchlistBloc = MovieDetailWatchlistBloc(
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchlistStatus: mockGetWatchListStatus,
    );
  });

  const tId = 1;

  blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
    'Should emit [AlreadyOnWatchlist] when get add is success',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('success'));
      return movieDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddToWatchlist(testMovieDetail)),
    expect: () => [
      UpdatingWatchlist(),
      AlreadyOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
    'Should emit [WatchlistError] when get add is failed',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('failure')));
      return movieDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlist(testMovieDetail)),
    expect: () => [
      UpdatingWatchlist(),
      const WatchlistError('failure'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
    'Should emit [NotOnWatchlist] when get remove is success',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('success'));
      return movieDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlist(testMovieDetail)),
    expect: () => [
      UpdatingWatchlist(),
      NotOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
    'Should emit [WatchlistError] when get remove is failed',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('fail')));
      return movieDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveWatchlist(testMovieDetail)),
    expect: () => [
      UpdatingWatchlist(),
      const WatchlistError('fail'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    },
  );

  blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
    'Should emit [AlreadyOnWatchList] when get status returning true',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieDetailWatchlistBloc;
    },
    act: (bloc) => bloc.add(const CheckWatchlistStatus(tId)),
    expect: () => [
      AlreadyOnWatchlist(),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieDetailWatchlistBloc, MovieDetailWatchlistState>(
    'Should emit [NotOnWatchlist] when get status returning false',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return movieDetailWatchlistBloc;
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
