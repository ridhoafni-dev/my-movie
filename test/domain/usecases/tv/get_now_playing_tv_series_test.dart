import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/usecases/tv/get_now_playing_tv_series.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvSeries usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetNowPlayingTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getNowPlayingTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvSeries));
  });
}
