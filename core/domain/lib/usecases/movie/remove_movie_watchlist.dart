import 'package:dartz/dartz.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/movie_repository.dart';

class RemoveMovieWatchlist {
  final MovieRepository repository;

  RemoveMovieWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
