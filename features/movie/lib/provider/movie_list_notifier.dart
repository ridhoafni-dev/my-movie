import 'package:domain/usecases/movie/get_now_playing_movies.dart';
import 'package:domain/usecases/movie/get_popular_movies.dart';
import 'package:domain/usecases/movie/get_top_rated_movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/movie/movie.dart';
import 'package:utils/utils/state_enum.dart';

class MovieListNotifier extends ChangeNotifier {

  late var _nowPlayingMovies = <Movie>[];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  late var _popularMovies = <Movie>[];
  List<Movie> get popularMovies => _popularMovies;

  late RequestState _nowPlayingMoviesState = RequestState.Empty;
  RequestState get nowPlayingMoviesState => _nowPlayingMoviesState;

  late RequestState _popularMoviesState = RequestState.Empty;
  RequestState get popularMoviesState => _popularMoviesState;

  late var _topRatedMovies = <Movie>[];
  List<Movie> get topRatedMovies => _topRatedMovies;

  late RequestState _topRatedMoviesState = RequestState.Empty;
  RequestState get topRatedMoviesState => _topRatedMoviesState;

  String _message = '';
  String get message => _message;

  MovieListNotifier({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  });

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchNowPlayingMovies() async {
    _popularMoviesState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        _nowPlayingMoviesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _nowPlayingMoviesState = RequestState.Loaded;
        _nowPlayingMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularMovies() async {
    _popularMoviesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        _popularMoviesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _popularMoviesState = RequestState.Loaded;
        _popularMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedMovies() async {
    _topRatedMoviesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        _topRatedMoviesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _topRatedMoviesState = RequestState.Loaded;
        _topRatedMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
