import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie/data/model/movie/movie_model.dart';
import '../../../features/search/lib/domain/entities/movie.dart';

void main() {
  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: '2020-05-05',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    video: false,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: '2020-05-05',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    video: false,
  );

  test("should be a subclass of Movie entity", () async {
    final result = tMovieModel.toEntity();

    expect(result, tMovie);
  });
}
