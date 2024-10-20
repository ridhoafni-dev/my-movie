import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/usecases/movie/get_popular_movies.dart';
import 'package:my_movie/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:my_movie/domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:my_movie/presentation/providers/movie/movie_list_notifier.dart';

import 'movie_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListNotifier provider;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    provider = MovieListNotifier(
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    )..addListener(() {
        listenerCallCount += 1;
      });
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
    voteAverage: 1,
    voteCount: 1,
    video: false,
  );
  final tMovieList = <Movie>[tMovie];

  // group('now playing movies', () {
  //   test('initialState should be Empty', () {
  //     expect(provider.nowPlayingState, equals(RequestState.Empty));
  //   });
  //
  //   test('should get data from the usecase', () async {
  //     // arrange
  //     when(mockGetNowPlayingMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     provider.fetchNowPlayingMovies();
  //     // assert
  //     verify(mockGetNowPlayingMovies.execute());
  //   });
  //
  //   test('should change state to Loading when usecase is called', () {
  //     // arrange
  //     when(mockGetNowPlayingMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     provider.fetchNowPlayingMovies();
  //     // assert
  //     expect(provider.nowPlayingState, RequestState.Loading);
  //   });
  //
  //   test('should change movies when data is gotten successfully', () async {
  //     // arrange
  //     when(mockGetNowPlayingMovies.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     // act
  //     await provider.fetchNowPlayingMovies();
  //     // assert
  //     expect(provider.nowPlayingState, RequestState.Loaded);
  //     expect(provider.nowPlayingMovies, tMovieList);
  //     expect(listenerCallCount, 2);
  //   });
  //
  //   test('should return error when data is unsuccessful', () async {
  //     // arrange
  //     when(mockGetNowPlayingMovies.execute())
  //         .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
  //     // act
  //     await provider.fetchNowPlayingMovies();
  //     // assert
  //     expect(provider.nowPlayingState, RequestState.Error);
  //     expect(provider.message, 'Server Failure');
  //     expect(listenerCallCount, 2);
  //   });
  // });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.Loaded);
      expect(provider.popularMovies, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.Loaded);
      expect(provider.topRatedMovies, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
