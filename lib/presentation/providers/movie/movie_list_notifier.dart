import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/usecases/movie/get_popular_movies.dart';

import '../../../domain/usecases/movie/get_top_rated_movies.dart';

class MovieListNotifier extends ChangeNotifier {

  late var _popularMovies = <Movie>[];
  List<Movie> get popularMovies => _popularMovies;

  late RequestState _popularMoviesState = RequestState.Empty;
  RequestState get popularMoviesState => _popularMoviesState;

  late var _topRatedMovies = <Movie>[];
  List<Movie> get topRatedMovies => _topRatedMovies;

  late RequestState _topRatedMoviesState = RequestState.Empty;
  RequestState get topRatedMoviesState => _topRatedMoviesState;

  String _message = '';
  String get message => _message;

  MovieListNotifier({
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  });

  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

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
