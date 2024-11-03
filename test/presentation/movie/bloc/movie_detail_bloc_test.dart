import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_movie_detail.dart';
import 'package:domain/usecases/movie/get_movie_recommendations.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';
import 'package:movie/bloc/detail/movie_detail_bloc.dart';
import 'package:movie/bloc/detail/movie_detail_event.dart';
import 'package:movie/bloc/detail/movie_detail_state.dart';
import 'package:utils/utils/failure.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();

    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  const tId = 1;

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

  final tMovies = <Movie>[tMovie];

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(movie: testMovieDetail, recommendations: tMovies),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    "Should emit [Loading, Error] when get fetch is failed",
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError('error'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );
}
