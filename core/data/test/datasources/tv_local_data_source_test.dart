import 'package:data/datasources/tv/tv_local_data_source.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utils/utils/exception.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSourceImpl;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSourceImpl =
        TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
        "should return success message when insert to database is success", () async {
      //arrange
      when(mockDatabaseHelper.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 1);

      //act
      final result = await dataSourceImpl
          .insertTvWatchlist(testTvTable);

      //assert
      expect(result, 'Added to Watchlist');
    });

    test(
        "should throw DatabaseException when insert to database is failed", () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testMovieTable))
          .thenThrow(Exception());

      // act
      final call = dataSourceImpl.insertTvWatchlist(testTvTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("remove watch", () {
    test(
        "should return success message when remove from database is success", () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTvTable)).thenAnswer((
          _) async => 1);

      // act
      final result = await dataSourceImpl
          .removeTvWatchlist(testTvTable);

      // assert
      expect(result, 'Removed from Watchlist');
    });

    test("should throw DatabaseException when remove from database is failed", () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
          .thenThrow(Exception());

      // act
      final call = dataSourceImpl.removeTvWatchlist(testTvTable);

      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("get detail tv by id", () {
    test("should return table detail tv when data is found", () async {
      // arrange
      when(mockDatabaseHelper.getTvById(1)).thenAnswer((_) async => testTvTable.toJson());

      // act
      final result = await dataSourceImpl.getTvById(1);

      // assert
      expect(result, testTvTable);
    });

    test("should return null when data is not found", () async {
      // arrange
      when(mockDatabaseHelper.getTvById(1)).thenAnswer((_) async => null);

      // act
      final result = await dataSourceImpl.getTvById(1);

      // assert
      expect(result, null);
    });
  });
}