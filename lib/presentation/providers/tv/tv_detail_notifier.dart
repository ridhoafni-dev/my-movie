import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/usecases/tv/get_tv_detail.dart';
import 'package:my_movie/domain/usecases/tv/get_tv_recommendations.dart';

import '../../../domain/entity/tv/tv_detail.dart';
import '../../../domain/usecases/tv/get_tv_watchlist_status.dart';
import '../../../domain/usecases/tv/remove_tv_watchlist.dart';
import '../../../domain/usecases/tv/save_tv_watchlist.dart';

class TvDetailNotifier extends ChangeNotifier {

  TvDetailNotifier(
      {required this.useCaseGetTvDetail,
      required this.useCaseGetTvRecommendations,
      required this.useCaseGetTvWatchlistStatus,
      required this.useCaseSaveWatchlist,
      required this.useCaseRemoveWatchlist});

  final GetTvDetail useCaseGetTvDetail;
  final GetTvRecommendations useCaseGetTvRecommendations;
  final GetTvWatchlistStatus useCaseGetTvWatchlistStatus;
  final SaveTvWatchlist useCaseSaveWatchlist;
  final RemoveTvWatchlist useCaseRemoveWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  late TvDetail _tvDetail;

  TvDetail get tvDetail => _tvDetail;
  RequestState _tvDetailState = RequestState.Empty;

  RequestState get tvDetailState => _tvDetailState;
  List<Tv> _tvRecommendations = [];

  List<Tv> get tvRecommendations => _tvRecommendations;
  RequestState _tvRecommendationsState = RequestState.Empty;

  RequestState get tvRecommendationsState => _tvRecommendationsState;

  String _message = '';
  String get message => _message;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvDetailState = RequestState.Loading;
    notifyListeners();
    final detailResult = await useCaseGetTvDetail.execute(id);
    final recommendationResult =
        await useCaseGetTvRecommendations.execute(id);
    detailResult.fold((failure) {
      _tvDetailState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tv) {
      _tvDetail = tv;
      _tvDetailState = RequestState.Loaded;
      notifyListeners();
    });
    recommendationResult.fold((failure) {
      _tvRecommendationsState = RequestState.Error;
      _message = failure.message;
    }, (movies) {
      _tvRecommendations = movies;
      _tvRecommendationsState = RequestState.Loaded;
    });
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await useCaseSaveWatchlist.execute(tv);
    await result.fold((failure) async {
      _watchlistMessage = failure.message;
    }, (successMessage) async {
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(tv.id);

  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await useCaseRemoveWatchlist.execute(tv);
    result.fold((failure) {
      _watchlistMessage = failure.message;
    }, (successMessage) {
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await useCaseGetTvWatchlistStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
