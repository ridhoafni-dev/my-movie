import 'package:dartz/dartz.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/tv_repository.dart';

class GetPopularTvSeries {
  final TvRepository repository;

  GetPopularTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTvSeries();
  }
}
