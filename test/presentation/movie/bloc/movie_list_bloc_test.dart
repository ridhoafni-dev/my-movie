import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_now_playing_movies.dart';
import 'package:domain/usecases/movie/get_popular_movies.dart';
import 'package:domain/usecases/movie/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';
import 'package:movie/bloc/list/movie_list_bloc.dart';
import 'package:movie/bloc/list/movie_list_event.dart';
import 'package:movie/bloc/list/movie_list_state.dart';
import 'package:utils/utils/failure.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;

  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));

      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchMovieList()),
    expect: () => [
      MovieListLoading(),
      MovieListHasData(
        nowPlaying: tMovieList,
        popular: tMovieList,
        topRated: tMovieList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetTopRatedMovies.execute());
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [Loading,Error] when get fetch is failed',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));

      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchMovieList()),
    expect: () => [MovieListLoading(), const MovieListError('fail')],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetTopRatedMovies.execute());
      verify(mockGetPopularMovies.execute());
    },
  );
}
