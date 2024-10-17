import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/usecases/tv/get_watchlist_tv_series.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  late final GetWatchlistTvSeries useCaseGetWatchlistTvSeries;

  RequestState _watchlistTvState = RequestState.Empty;
  RequestState get watchlistTvState => _watchlistTvState;

  List<Tv> _watchlistTvSeries = [];
  List<Tv> get watchlistTvSeries => _watchlistTvSeries;

  String _message = '';
  String get message => _message;

  WatchlistTvNotifier({required this.useCaseGetWatchlistTvSeries});

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistTvState = RequestState.Loading;
    notifyListeners();
    final result = await useCaseGetWatchlistTvSeries.execute();
    result.fold((failure) {
      _watchlistTvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeries) {
      _watchlistTvState = RequestState.Loaded;
      _watchlistTvSeries = tvSeries;
      notifyListeners();
    });
  }

}
