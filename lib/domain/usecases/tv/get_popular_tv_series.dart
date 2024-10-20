import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';

import '../../repositories/tv_repository.dart';

class GetPopularTvSeries {
  final TvRepository repository;

  GetPopularTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTvSeries();
  }
}
