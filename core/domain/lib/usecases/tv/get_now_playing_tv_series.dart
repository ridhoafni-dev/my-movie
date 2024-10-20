import 'package:dartz/dartz.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/tv_repository.dart';

class GetNowPlayingTvSeries {
  final TvRepository repository;

  GetNowPlayingTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getNowPlayingTvSeries();
  }
}
