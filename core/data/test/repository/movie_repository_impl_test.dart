import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:data/repositories/movie_repository_impl.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';
import 'package:response/genre/genre_model.dart';
import 'package:response/movie/movie_detail_response.dart';
import 'package:response/movie/movie_model.dart';
import 'package:utils/utils.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl movieRepositoryImpl;
  late MockMovieLocalDataSource mockMovieLocalDataSource;
  late MockMovieRemoteDataSource mockMovieRemoteDataSource;

  setUp(() {
    mockMovieRemoteDataSource = MockMovieRemoteDataSource();
    mockMovieLocalDataSource = MockMovieLocalDataSource();
    movieRepositoryImpl = MovieRepositoryImpl(
        movieRemoteDataSource: mockMovieRemoteDataSource,
        movieLocalDataSource: mockMovieLocalDataSource);
  });

  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
    video: false,
  );

  final tMovie = Movie(
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
    voteAverage: 7.2,
    voteCount: 13507,
    video: false,
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getPopularMovies())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await movieRepositoryImpl.getPopularMovies();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getPopularMovies())
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await movieRepositoryImpl.getPopularMovies();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getPopularMovies())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await movieRepositoryImpl.getPopularMovies();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await movieRepositoryImpl.getTopRatedMovies();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getTopRatedMovies())
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await movieRepositoryImpl.getTopRatedMovies();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getTopRatedMovies())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await movieRepositoryImpl.getTopRatedMovies();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Movie Detail', () {
    const tId = 1;
    const tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
      runtime: 120,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getMovieDetail(tId))
          .thenAnswer((_) async => tMovieResponse);
      // act
      final result = await movieRepositoryImpl.getMovieDetail(tId);
      // assert
      verify(mockMovieRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(const Right(testMovieDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getMovieDetail(tId))
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await movieRepositoryImpl.getMovieDetail(tId);
      // assert
      verify(mockMovieRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getMovieDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await movieRepositoryImpl.getMovieDetail(tId);
      // assert
      verify(mockMovieRemoteDataSource.getMovieDetail(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    const tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await movieRepositoryImpl.getMovieRecommendations(tId);
      // assert
      verify(mockMovieRemoteDataSource.getMovieRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await movieRepositoryImpl.getMovieRecommendations(tId);
      // assertbuild runner
      verify(mockMovieRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await movieRepositoryImpl.getMovieRecommendations(tId);
      // assert
      verify(mockMovieRemoteDataSource.getMovieRecommendations(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Movies', () {
    const tQuery = 'spider man';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await movieRepositoryImpl.searchMovies(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.searchMovies(tQuery))
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await movieRepositoryImpl.searchMovies(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockMovieRemoteDataSource.searchMovies(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await movieRepositoryImpl.searchMovies(tQuery);
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockMovieLocalDataSource.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await movieRepositoryImpl.saveWatchlist(testMovieDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockMovieLocalDataSource.insertWatchlist(testMovieTable)).thenThrow(
          const DatabaseException(message: 'Failed to add watchlist'));
      // act
      final result = await movieRepositoryImpl.saveWatchlist(testMovieDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockMovieLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await movieRepositoryImpl.removeWatchlist(testMovieDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockMovieLocalDataSource.removeWatchlist(testMovieTable)).thenThrow(
          const DatabaseException(message: 'Failed to remove watchlist'));
      // act
      final result = await movieRepositoryImpl.removeWatchlist(testMovieDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockMovieLocalDataSource.getMovieById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await movieRepositoryImpl.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockMovieLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await movieRepositoryImpl.getWatchlistMovies();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });
}
