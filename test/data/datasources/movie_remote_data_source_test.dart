import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/exception.dart';
import 'package:my_movie/data/datasources/movie_remote_data_source.dart';
import 'package:my_movie/data/model/movie/movie_detail_response.dart';
import 'package:my_movie/data/model/movie/movie_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../utils/json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  // group('get now playing movies', () {
  //   // final dummyMovieList = MovieResponse
  //   //     .fromJson(
  //   //     json.decode(readJson('dummy_data/now_playing.json'))
  //   // )
  //   //     .movieList;
  //
  //
  //   // test('should return list of movies when response code is 200 ', () async {
  //   //   // assert
  //   //   when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'))).thenAnswer((_) async =>
  //   //       http.Response(readJson('dummy_data/now_playing.json'), 200));
  //   //
  //   //   final result = await dataSourceImpl.getNowPlayingTvSeries();
  //   //   // assert
  //   //   expect(result, equals(dummyMovieList));
  //   // });
  //
  //   //   test("should throw ServerException when response code isn't 200", () async {
  //   //     //arrange
  //   //     when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today'), headers: {
  //   //       "Accept": "application/json",
  //   //       "Authorization": "Bearer $ACCESS_TOKEN",
  //   //     })).thenThrow((_) async => http.Response('Not Found', 404));
  //   //
  //   //     //act
  //   //     final call = dataSourceImpl.getNowPlayingTvSeries();
  //   //
  //   //     //assert
  //   //     expect(() => call, throwsA(isA<ServerException>()));
  //   //   });
  //   // });
  // }

  group("get top rated movies", () {
    final dummyMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated.json')))
        .movieList;

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated.json'), 200));

      // act
      final result = await dataSourceImpl.getTopRatedMovies();

      // assert
      expect(result, equals(dummyMovieList));
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')))
          .thenThrow((_) async => http.Response('Not Found', 404));

      // act
      final call = dataSourceImpl.getTopRatedMovies();

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get movie detail', () {
    const tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/movie_detail.json'), 200));
      // act
      final result = await dataSourceImpl.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      // act
      when(mockHttpClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSourceImpl.getMovieDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get movie recommendations', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie_recommendations.json')))
        .movieList;
    const tId = 1;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie_recommendations.json'), 200));
      // act
      final result = await dataSourceImpl.getMovieRecommendations(tId);
      // assert
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getMovieRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .movieList;

    const tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // assert
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_movie.json'), 200));

      final result = await dataSourceImpl.searchMovies(tQuery);
      // assert
      expect(result, equals(tSearchResult));
    });
  });
}
