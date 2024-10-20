import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  const tId = 1;
  const tTvSeries = <Tv>[];

  test('should get list of tv series recommendations from the repository',
      () async {
    // arrange
    when(mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => const Right(tTvSeries));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, const Right(tTvSeries));
  });
}
