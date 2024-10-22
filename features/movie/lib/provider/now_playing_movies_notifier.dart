import 'package:domain/usecases/movie/get_now_playing_movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/movie/movie.dart';
import 'package:utils/utils/state_enum.dart';

class NowPlayingMoviesNotifier extends ChangeNotifier {
  late final GetNowPlayingMovies useCaseGetNowPlayingMovies;

  NowPlayingMoviesNotifier({required this.useCaseGetNowPlayingMovies});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingMovies() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetNowPlayingMovies.execute();
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (moviesData) {
      _state = RequestState.Loaded;
      _nowPlayingMovies = moviesData;
      notifyListeners();
    });
  }
}
