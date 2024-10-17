import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/repositories/tv_repository.dart';

class SearchTvSeries {
  final TvRepository repository;

  SearchTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}
