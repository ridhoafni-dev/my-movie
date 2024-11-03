import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/search_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';
import 'package:search/bloc/movie/movie_search_bloc.dart';
import 'package:search/bloc/movie/movie_search_event.dart';
import 'package:search/bloc/movie/movie_search_state.dart';
import 'package:utils/utils/failure.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;

  late MovieSearchBloc movieSearchBloc;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(const SearchMovie(tQuery)),
    expect: () => [
      MovieSearchLoading(),
      MovieSearchHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Error] when get fetch is failed',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(const SearchMovie(tQuery)),
    expect: () => [
      MovieSearchLoading(),
      const MovieSearchError('fail'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
}
