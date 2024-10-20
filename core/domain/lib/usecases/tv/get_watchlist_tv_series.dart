import 'package:dartz/dartz.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/tv_repository.dart';

class GetWatchlistTvSeries {
  final TvRepository repository;

  GetWatchlistTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getWatchlistTvSeries();
  }
}
