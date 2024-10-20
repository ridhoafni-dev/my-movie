import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/get_tv_detail.dart';
import 'package:dummy_data/dummy_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  const tId = 1;

  test('should get tv detail from repository', () async {
    // arrange
    when(mockTvRepository.getTvDetail(tId))
        .thenAnswer((_) async => const Right(testTvDetail));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, const Right(testTvDetail));
    verify(mockTvRepository.getTvDetail(tId)).called(1);
  });
}
