import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/exception.dart';
import 'package:my_movie/data/datasources/movie_local_data_source.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSourceImpl;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSourceImpl =
        MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
        "should return success message when insert to database is success", () async {
      //arrange
      when(mockDatabaseHelper.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 1);

      //act
      final result = await dataSourceImpl
          .insertWatchlist(testMovieTable);

      //assert
      expect(result, 'Added to Watchlist');
    });

    test(
        "should throw DatabaseException when insert to database is failed", () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testMovieTable))
          .thenThrow(Exception());

      // act
      final call = dataSourceImpl.insertWatchlist(testMovieTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("remove watch", () {
    test(
        "should return success message when remove from database is success", () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(testMovieTable)).thenAnswer((
          _) async => 1);

      // act
      final result = await dataSourceImpl
          .removeWatchlist(testMovieTable);

      // assert
      expect(result, 'Removed from Watchlist');
    });

    test("should throw DatabaseException when remove from database is failed", () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(testMovieTable))
          .thenThrow(Exception());

      // act
      final call = dataSourceImpl.removeWatchlist(testMovieTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("get detail movie by id", () {
    test("should return table detail movie when data is found", () async {
      // arrange
      when(mockDatabaseHelper.getMovieById(1)).thenAnswer((_) async => testMovieTable.toJson());

      // act
      final result = await dataSourceImpl.getMovieById(1);

      // assert
      expect(result, testMovieTable);
    });

    test("should return null when data is not found", () async {
      // arrange
      when(mockDatabaseHelper.getMovieById(1)).thenAnswer((_) async => null);

      // act
      final result = await dataSourceImpl.getMovieById(1);

      // assert
      expect(result, null);
    });
  });
}