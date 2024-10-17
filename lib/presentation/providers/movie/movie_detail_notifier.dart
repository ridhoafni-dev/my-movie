import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/usecases/movie/get_movie_detail.dart';
import 'package:my_movie/domain/usecases/movie/get_movie_watchlist_status.dart';
import 'package:my_movie/domain/usecases/movie/remove_movie_watchlist.dart';
import 'package:my_movie/domain/usecases/movie/save_movie_watchlist.dart';

import '../../../domain/entity/movie/movie_detail.dart';
import '../../../domain/usecases/movie/get_movie_recommendations.dart';

class MovieDetailNotifier extends ChangeNotifier {
   final GetMovieDetail useCaseGetMovieDetail;
   final GetMovieRecommendations useCaseGetMovieRecommendations;
   final GetMovieWatchListStatus useCaseGetWatchListStatus;
   final SaveMovieWatchlist useCaseSaveWatchlist;
   final RemoveMovieWatchlist useCaseRemoveWatchlist;

  MovieDetailNotifier(
      {required this.useCaseGetMovieDetail,
      required this.useCaseGetMovieRecommendations,
      required this.useCaseGetWatchListStatus,
      required this.useCaseSaveWatchlist,
      required this.useCaseRemoveWatchlist});

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  late MovieDetail _movieDetail;

  MovieDetail get movieDetail => _movieDetail;
  RequestState _movieDetailState = RequestState.Empty;

  RequestState get movieDetailState => _movieDetailState;
  List<Movie> _movieRecommendations = [];

  List<Movie> get movieRecommendations => _movieRecommendations;
  RequestState _movieRecommendationsState = RequestState.Empty;

  RequestState get movieRecommendationsState => _movieRecommendationsState;

  String _message = '';
  String get message => _message;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    _movieDetailState = RequestState.Loading;
    notifyListeners();
    final detailResult = await useCaseGetMovieDetail.execute(id);
    final recommendationResult =
        await useCaseGetMovieRecommendations.execute(id);
    detailResult.fold((failure) {
      _movieDetailState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (movie) {
      _movieDetail = movie;
      _movieDetailState = RequestState.Loaded;
      notifyListeners();
    });
    recommendationResult.fold((failure) {
      _movieRecommendationsState = RequestState.Error;
      _message = failure.message;
    }, (movies) {
      _movieRecommendations = movies;
      _movieRecommendationsState = RequestState.Loaded;
    });
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await useCaseSaveWatchlist.execute(movie);
    await result.fold((failure) async {
      _watchlistMessage = failure.message;
    }, (successMessage) async {
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(movie.id);

  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await useCaseRemoveWatchlist.execute(movie);
    result.fold((failure) {
      _watchlistMessage = failure.message;
    }, (successMessage) {
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await useCaseGetWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
