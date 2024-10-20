import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_movie_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetMovieRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieRecommendations(mockMovieRepository);
  });

  const tId = 1;
  const tMovies = <Movie>[];

  test('should get list of movie recommendations from the repository', () async {
   // arrange
    when(mockMovieRepository.getMovieRecommendations(tId)).thenAnswer((_) async => const Right(tMovies));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, const Right(tMovies));

  });
}