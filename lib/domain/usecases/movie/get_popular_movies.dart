import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
