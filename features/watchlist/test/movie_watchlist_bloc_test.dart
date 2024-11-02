import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_watchlist_movies.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:utils/utils/failure.dart';
import 'package:watchlist/bloc/movie/movie_watchlist_bloc.dart';
import 'package:watchlist/bloc/movie/movie_watchlist_event.dart';
import 'package:watchlist/bloc/movie/movie_watchlist_state.dart';

import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  late MovieWatchlistBloc movieWatchlistBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    movieWatchlistBloc = MovieWatchlistBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
    );
  });

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovies()),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistHasData(watchlist: [testWatchlistMovie]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Left(DatabaseFailure('fail')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovies()),
    expect: () => [
      MovieWatchlistLoading(),
      const MovieWatchlistError('fail'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
