import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/domain/usecases/movie/get_movie_detail.dart';

import '../../../dummy_data/dummy_object.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;


  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  const tId = 1;

  test('should get movie detail from repository', () async {
    // arrange
    when(mockMovieRepository.getMovieDetail(tId)).thenAnswer((_) async => const Right(testMovieDetail));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, const Right(testMovieDetail));
    verify(mockMovieRepository.getMovieDetail(tId)).called(1);
  });
}