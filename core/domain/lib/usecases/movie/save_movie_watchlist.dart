import 'package:dartz/dartz.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/movie_repository.dart';

class SaveMovieWatchlist {
  final MovieRepository repository;

  SaveMovieWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
