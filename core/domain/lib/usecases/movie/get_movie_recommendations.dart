import 'package:dartz/dartz.dart';
import 'package:model/movie/movie.dart';
import 'package:utils/utils/failure.dart';
import '../../repositories/movie_repository.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}
