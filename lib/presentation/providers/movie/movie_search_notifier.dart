import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/usecases/movie/search_movies.dart';

class MovieSearchNotifier extends ChangeNotifier {
  final SearchMovies useCaseGetSearchMovies;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _searchResult = [];
  List<Movie> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  MovieSearchNotifier({required this.useCaseGetSearchMovies});

  Future<void> fetchMovieSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetSearchMovies.execute(query);
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (data) {
      _state = RequestState.Loaded;
      _searchResult = data;
      notifyListeners();
    });
  }

  Future<void> resetState() {
    _state = RequestState.Empty;
    _message = '';
    _searchResult = [];
    return Future.value();
  }
}
