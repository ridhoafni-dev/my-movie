import 'package:my_movie/common/exception.dart';
import 'package:my_movie/data/datasources/db/database_helper.dart';
import 'package:my_movie/data/model/tv/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertTvWatchlist(TvTable tv);

  Future<String> removeTvWatchlist(TvTable tv);

  Future<TvTable?> getTvById(int id);

  Future<List<TvTable>> getWatchlistTvSeries();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<TvTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertTvWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertTvWatchlist(tv);
      return Future.value('Added to Watchlist');
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<String> removeTvWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeTvWatchlist(tv);
      return Future.value('Removed from Watchlist');
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getMovieById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }
}
