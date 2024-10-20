import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/exception.dart';
import 'package:my_movie/data/datasources/tv_remote_data_source.dart';
import 'package:my_movie/data/model/tv/tv_detail_response.dart';
import 'package:my_movie/data/model/tv/tv_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../utils/json_reader.dart';

void main() {
  const String ACCESS_TOKEN =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNmRhYzQ1YWNlZmQzZmRkNDBhOTcwNTQ1ZjhlZGU4NSIsIm5iZiI6MTcyODc0NzQzOC45NTcwMDYsInN1YiI6IjY3MGE5MmM3YjE1ZDk3YjFhOTNjMTM1NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.bd-SZkgrdX7sLktelPdhSZi49Q2tIXHsjL0gnTOCaOc';
  const String BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get now playing tv series', () {
    final dummyTvList = TvResponse
        .fromJson(
        json.decode(readJson('dummy_data/now_playing.json'))
    )
        .tvList;

    test('should return list of tv when response code is 200 ', () async {
      // assert
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $ACCESS_TOKEN",
      })).thenAnswer((_) async =>
          http.Response(readJson('dummy_data/now_playing.json'), 200));

      final result = await dataSourceImpl.getNowPlayingTvSeries();
      // assert
      expect(result, equals(dummyTvList));
    });

      test("should throw ServerException when response code isn't 200", () async {
        //arrange
        when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today'), headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $ACCESS_TOKEN",
        })).thenThrow((_) async => http.Response('Not Found', 404));

        //act
        final call = dataSourceImpl.getNowPlayingTvSeries();

        //assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

  group('get recommendation tv series', () {
    final dummyTvList = TvResponse
        .fromJson(
        json.decode(readJson('dummy_data/tv_recommendations.json'))
    )
        .tvList;

    const tId = 1;

    test('should return list of tv when response code is 200 ', () async {
      // assert
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/recommendations'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $ACCESS_TOKEN",
      })).thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_recommendations.json'), 200));

      final result = await dataSourceImpl.getTvRecommendations(tId);
      // assert
      expect(result, equals(dummyTvList));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/recommendations'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $ACCESS_TOKEN",
      })).thenThrow((_) async => http.Response('Not Found', 404));

      //act
      final call = dataSourceImpl.getTvRecommendations(tId);

      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
  
  group('get tv detail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $ACCESS_TOKEN",
      }))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSourceImpl.getTvDetail(tId);
      // assert
      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      // act
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId'), headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $ACCESS_TOKEN",
          }))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSourceImpl.getTvDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tSearchResult = TvResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_tv.json')))
        .tvList;

    const tQuery = 'Spiderman';

    test('should return list of tv series when response code is 200', () async {
      // assert
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?&query=$tQuery'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $ACCESS_TOKEN",
      }))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_tv.json'), 200));

      final result = await dataSourceImpl.searchTvSeries(tQuery);
      // assert
      expect(result, equals(tSearchResult));
    });
  });
}
