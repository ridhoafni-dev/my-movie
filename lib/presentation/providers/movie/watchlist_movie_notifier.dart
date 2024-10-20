import 'package:domain/usecases/movie/get_watchlist_movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/movie/movie.dart';
import 'package:utils/utils/state_enum.dart';

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
