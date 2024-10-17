import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/repositories/movie_repository.dart';

import '../../entity/movie/movie_detail.dart';

class SaveMovieWatchlist {
  final MovieRepository repository;

  SaveMovieWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
