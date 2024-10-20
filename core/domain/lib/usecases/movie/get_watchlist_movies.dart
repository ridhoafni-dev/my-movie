import 'package:dartz/dartz.dart';
import 'package:model/movie/movie.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/movie_repository.dart';

class GetWatchlistMovies {
  final MovieRepository repository;

  GetWatchlistMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getWatchlistMovies();
  }
}
