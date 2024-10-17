import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/repositories/tv_repository.dart';

class GetTvRecommendations {

  GetTvRecommendations(this.repository);

  final TvRepository repository;

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return repository.getTvRecommendations(id);
  }
}
