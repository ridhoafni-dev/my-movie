import 'package:dartz/dartz.dart';
import 'package:model/tv/tv_detail.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/tv_repository.dart';

class SaveTvWatchlist {

  SaveTvWatchlist(this.repository);

  final TvRepository repository;

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.saveWatchlist(tv);
  }
}
