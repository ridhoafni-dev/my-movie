import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';

import '../../../domain/usecases/movie/get_top_rated_movies.dart';

class TopRatedMoviesNotifier extends ChangeNotifier {
  late final GetTopRatedMovies useCaseGetTopRatedMovies;

  TopRatedMoviesNotifier({required this.useCaseGetTopRatedMovies});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Movie> _topRatedMovies = [];

  List<Movie> get topRatedMovies => _topRatedMovies;

  String _message = '';

  String get message => _message;

  Future<void> fetchTopRatedMovies() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetTopRatedMovies.execute();
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (moviesData) {
      _topRatedMovies = moviesData;
      _state = RequestState.Loaded;
      notifyListeners();
    });
  }
}
