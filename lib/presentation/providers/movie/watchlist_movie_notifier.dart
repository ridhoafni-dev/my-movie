import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';

import '../../../domain/usecases/movie/get_watchlist_movies.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  late final GetWatchlistMovies useCaseGetWatchlistMovies;

  RequestState _watchlistState = RequestState.Empty;

  RequestState get watchlistState => _watchlistState;

  List<Movie> _watchlistMovies = [];

  List<Movie> get watchlistMovies => _watchlistMovies;

  String _message = '';

  String get message => _message;

  WatchlistMovieNotifier({required this.useCaseGetWatchlistMovies});

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();
    final result = await useCaseGetWatchlistMovies.execute();
    result.fold((failure) {
      _watchlistState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (movies) {
      _watchlistState = RequestState.Loaded;
      _watchlistMovies = movies;
      notifyListeners();
    });
  }
}
