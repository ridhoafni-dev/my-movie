import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/repositories/movie_repository.dart';

import '../../entity/movie/movie_detail.dart';

class RemoveMovieWatchlist {
  final MovieRepository repository;

  RemoveMovieWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
