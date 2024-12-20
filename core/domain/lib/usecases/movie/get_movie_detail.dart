import 'package:dartz/dartz.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
