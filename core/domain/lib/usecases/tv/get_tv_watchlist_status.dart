import '../../repositories/tv_repository.dart';

class GetTvWatchlistStatus {

  GetTvWatchlistStatus(this.repository);

  final TvRepository repository;

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
