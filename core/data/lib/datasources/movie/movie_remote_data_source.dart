import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:response/movie/movie_detail_response.dart';
import 'package:response/movie/movie_model.dart';
import 'package:response/movie/movie_response.dart';
import 'package:utils/utils/exception.dart';


abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();

  Future<List<MovieModel>> getPopularMovies();

  Future<List<MovieModel>> getTopRatedMovies();

  Future<MovieDetailResponse> getMovieDetail(int id);

  Future<List<MovieModel>> getMovieRecommendations(int id);

  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';

  static const String ACCESS_TOKEN =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNmRhYzQ1YWNlZmQzZmRkNDBhOTcwNTQ1ZjhlZGU4NSIsIm5iZiI6MTcyODc0NzQzOC45NTcwMDYsInN1YiI6IjY3MGE5MmM3YjE1ZDk3YjFhOTNjMTM1NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.bd-SZkgrdX7sLktelPdhSZi49Q2tIXHsjL0gnTOCaOc';
  static const String BASE_URL = 'https://api.themoviedb.org/3';

  late final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final response =
      await client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));
      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error--> $e");
      }
      throw const ServerException(message: "Failed to connect to server");
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    try {
      final response =
      await client.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error--> $e");
      }

      throw const ServerException(message: "Failed to connect to server");
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/movie/$id/recommendations?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error--> $e");
      }

      throw const ServerException(message: "Failed to connect to server");
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response =
      await client.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'));
      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error--> $e");
      }
      throw const ServerException(message: "Failed to connect to server");
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response =
      await client.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw const ServerException(message: "Failed to connect to server");
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$query'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw const ServerException(message: "Failed to connect to server");
    }
  }

  debugPrint(String message) {
    if (kDebugMode) {
      print("Error--> $message");
    }
  }
}

