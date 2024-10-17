import 'package:dartz/dartz.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/domain/entity/tv/tv_detail.dart';

import '../../repositories/tv_repository.dart';

class RemoveTvWatchlist {

  RemoveTvWatchlist(this.repository);

  final TvRepository repository;

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlist(tv);
  }
}
