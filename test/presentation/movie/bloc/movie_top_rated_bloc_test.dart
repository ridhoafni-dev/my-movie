import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_bloc.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_event.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_state.dart';
import 'package:utils/utils.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  late MovieTopRatedBloc movieTopRatedBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieTopRatedBloc =
        MovieTopRatedBloc(getTopRatedMovies: mockGetTopRatedMovies);
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

  blocTest<MovieTopRatedBloc, MovieTopRatedState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return movieTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovie()),
    expect: () => [
      MovieTopRatedLoading(),
      MovieTopRatedHasData(topRated: tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<MovieTopRatedBloc, MovieTopRatedState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      return movieTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovie()),
    expect: () => [
      MovieTopRatedLoading(),
      const MovieTopRatedError('fail'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
