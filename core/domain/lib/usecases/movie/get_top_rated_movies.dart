import 'package:dartz/dartz.dart';
import 'package:model/movie/movie.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/movie_repository.dart';

class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getTopRatedMovies();
  }
}
