import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/repositories/movie_repository.dart';

import '../../entity/movie/movie_detail.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
