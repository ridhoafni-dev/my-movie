import 'package:dartz/dartz.dart';
import 'package:model/tv/tv_detail.dart';
import 'package:utils/utils/failure.dart';

import '../../repositories/tv_repository.dart';

class GetTvDetail {

  GetTvDetail(this.repository);

  final TvRepository repository;

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
