import 'package:flutter_test/flutter_test.dart';
import 'package:model/tv/tv.dart';
import 'package:response/tv/tv_model.dart';

void main() {
  const tTvModel = TvModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: '2020-05-05',
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: '2020-05-05',
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test("should be a subclass of Tv entity", () async {
    final result = tTvModel.toEntity();

    expect(result, tTv);
  });
}
