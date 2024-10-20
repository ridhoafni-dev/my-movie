import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie/data/model/movie/movie_model.dart';
import 'package:my_movie/data/model/movie/movie_response.dart';

import '../../utils/json_reader.dart';

void main() {
  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalTitle: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    title: "Title",
    voteAverage: 1.0,
    voteCount: 1,
    video: false,
  );

  const tMovieResponseModel =
      MovieResponse(movieList: <MovieModel>[tMovieModel]);

  group("from json", () {
    test("should return valid model from json", () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson("dummy_data/movie_recommendations.json"));

      // act
      final result = MovieResponse.fromJson(jsonMap);

      // assert
      expect(result, tMovieResponseModel);
    });

  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            'adult': false,
            'backdrop_path': '/path.jpg',
            'genre_ids': [1, 2, 3, 4],
            'id': 1,
            'original_title': 'Original Title',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': '/path.jpg',
            'release_date': '2020-05-05',
            'video': false,
            'title': 'Title',
            'vote_average': 1.0,
            'vote_count': 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
