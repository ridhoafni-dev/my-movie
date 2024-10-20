import 'package:dartz/dartz.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/tv_repository.dart';

class GetTvRecommendations {

  GetTvRecommendations(this.repository);

  final TvRepository repository;

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return repository.getTvRecommendations(id);
  }
}
