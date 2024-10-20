import 'package:dartz/dartz.dart';
import 'package:domain/usecases/movie/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:model/movie/movie.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  final tMovies = <Movie>[];

  test(
      'should get list of movies from the repository when execute function is called',
      () async {
    // arrange
    when(mockMovieRpository.getPopularMovies())
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });
}
