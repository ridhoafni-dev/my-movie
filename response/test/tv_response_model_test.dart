import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie/data/model/tv/tv_model.dart';
import 'package:my_movie/data/model/tv/tv_response.dart';

import '../../utils/json_reader.dart';

void main() {
  const tTvModel = TvModel(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    name: "Title",
    voteAverage: 1.0,
    voteCount: 1,
  );

  const tTvResponseModel =
      TvResponse(tvList: <TvModel>[tTvModel]);

  group("from json", () {
    test("should return valid model from json", () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson("dummy_data/tv_recommendations.json"));

      // act
      final result = TvResponse.fromJson(jsonMap);

      // assert
      expect(result, tTvResponseModel);
    });

  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            'adult': false,
            'backdrop_path': '/path.jpg',
            'genre_ids': [1, 2, 3, 4],
            'id': 1,
            'original_name': 'Original Title',
            'overview': 'Overview',
            'popularity': 1.0,
            'poster_path': '/path.jpg',
            'release_date': '2020-05-05',
            'name': 'Title',
            'vote_average': 1.0,
            'vote_count': 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
