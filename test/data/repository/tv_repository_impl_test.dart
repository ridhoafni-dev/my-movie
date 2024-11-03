import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:data/repositories/tv_repository_impl.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';
import 'package:response/genre/genre_model.dart';
import 'package:response/tv/tv_detail_response.dart';
import 'package:response/tv/tv_model.dart';
import 'package:utils/utils/exception.dart';
import 'package:utils/utils/failure.dart';

import '../../helpers/test_helper.mocks.dart';


void main() {
  late TvRepositoryImpl tvRepositoryImpl;
  late MockTvLocalDataSource mockTvLocalDataSource;
  late MockTvRemoteDataSource mockTvRemoteDataSource;

  setUp(() {
    mockTvRemoteDataSource = MockTvRemoteDataSource();
    mockTvLocalDataSource = MockTvLocalDataSource();
    tvRepositoryImpl = TvRepositoryImpl(
        tvRemoteDataSource: mockTvRemoteDataSource,
        tvLocalDataSource: mockTvLocalDataSource);
  });

  const tTvModel = TvModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group("now playing tv series", () {
    test("should return data when call to remote data source is success",
        () async {
      // arrange
      when(mockTvRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => tTvModelList);

      // act
      final result = await tvRepositoryImpl.getNowPlayingTvSeries();

      // assert
      verify(mockTvRemoteDataSource.getNowPlayingTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        "should return server failure when call to remote data source is unsuccessful",
        () async {
      // arrange
      when(mockTvRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(const ServerException(message: ''));

      // act
      final result = await tvRepositoryImpl.getNowPlayingTvSeries();

      // assert
      verify(mockTvRemoteDataSource.getNowPlayingTvSeries());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        "should return connection failure when device is not connected to internet",
        () async {
      // arrange
      when(mockTvRemoteDataSource.getNowPlayingTvSeries()).thenThrow(
          const SocketException("Failed to connect to the internet"));

      // act
      final result = await tvRepositoryImpl.getNowPlayingTvSeries();

      // assert
      verify(mockTvRemoteDataSource.getNowPlayingTvSeries());
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Detail', () {
    const tId = 1;
    const tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      originalLanguage: 'en',
      originalName: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      status: 'Status',
      tagline: 'Tagline',
      name: 'title',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      // act
      final result = await tvRepositoryImpl.getTvDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result, equals(const Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await tvRepositoryImpl.getTvDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await tvRepositoryImpl.getTvDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvDetail(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    const tId = 1;

    test('should return data (tv list) when the call is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvList);
      // act
      final result = await tvRepositoryImpl.getTvRecommendations(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await tvRepositoryImpl.getTvRecommendations(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await tvRepositoryImpl.getTvRecommendations(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvRecommendations(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Tv Series', () {
    const tQuery = 'spider man';

    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await tvRepositoryImpl.searchTvSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(const ServerException(message: ''));
      // act
      final result = await tvRepositoryImpl.searchTvSeries(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await tvRepositoryImpl.searchTvSeries(tQuery);
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
    when(mockTvLocalDataSource.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await tvRepositoryImpl.saveWatchlist(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.insertTvWatchlist(testTvTable)).thenThrow(
          const DatabaseException(message: 'Failed to add watchlist'));
      // act
      final result = await tvRepositoryImpl.saveWatchlist(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful ', () async {
      // arrange
      when(mockTvLocalDataSource.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await tvRepositoryImpl.removeWatchlist(testTvDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.removeTvWatchlist(testTvTable)).thenThrow(
          const DatabaseException(message: 'Failed to remove watchlist'));
      // act
      final result = await tvRepositoryImpl.removeWatchlist(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockTvLocalDataSource.getTvById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await tvRepositoryImpl.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  // group('get watchlist tv series', () {
  //   test('should return list of tv series', () async {
  //     // arrange
  //     when(mockTvLocalDataSource.getWatchlistTvSeries())
  //         .thenAnswer((_) async => [testTvTable]);
  //     // act
  //     final result = await tvRepositoryImpl.getWatchlistTvSeries();
  //     // assert
  //     final resultList = result.getOrElse(() => []);
  //     expect(resultList, [testWatchlistTv]);
  //   });
  // });
}
