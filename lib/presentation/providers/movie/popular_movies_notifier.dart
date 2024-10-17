import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/usecases/movie/get_popular_movies.dart';

class PopularMoviesNotifier extends ChangeNotifier {
  late final GetPopularMovies useCaseGetPopularMovies;

  PopularMoviesNotifier({required this.useCaseGetPopularMovies});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularMovies() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetPopularMovies.execute();
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (moviesData) {
      _state = RequestState.Loaded;
      _popularMovies = moviesData;
      notifyListeners();
    });
  }
}
