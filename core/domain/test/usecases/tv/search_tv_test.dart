import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:model/tv/tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];
  const tQuery = 'Spiderman';

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvSeries));
  });
}
