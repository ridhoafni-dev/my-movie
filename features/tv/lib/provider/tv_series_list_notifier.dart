import 'package:domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:domain/usecases/tv/get_popular_tv_series.dart';
import 'package:domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/state_enum.dart';

class TvSeriesListNotifier extends ChangeNotifier {

  late var _nowPlayingTvSeries = <Tv>[];
  List<Tv> get nowPlayingTvSeries => _nowPlayingTvSeries;

  late var _popularTvSeries = <Tv>[];
  List<Tv> get popularTvSeries => _popularTvSeries;

  late var _topRatedTvSeries = <Tv>[];
  List<Tv> get topRatedTvSeries => _topRatedTvSeries;

  late RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  late RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  late RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  TvSeriesListNotifier({
    required this.useCaseGetNowPlayingTvSeries,
    required this.useCaseGetPopularTvSeries,
    required this.useCaseGetTopRatedTvSeries,
  });

  final GetNowPlayingTvSeries useCaseGetNowPlayingTvSeries;
  final GetPopularTvSeries useCaseGetPopularTvSeries;
  final GetTopRatedTvSeries useCaseGetTopRatedTvSeries;

  Future<void> fetchNowPlayingTvSeries() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetNowPlayingTvSeries.execute();
    result.fold((failure) {
      _nowPlayingState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _nowPlayingState = RequestState.Loaded;
      _nowPlayingTvSeries = tvSeriesData;
      notifyListeners();
    });
  }

  Future<void> fetchPopularTvSeries() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetPopularTvSeries.execute();
    result.fold((failure) {
      _popularState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _popularState = RequestState.Loaded;
      _popularTvSeries = tvSeriesData;
      notifyListeners();
    });
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetTopRatedTvSeries.execute();
    result.fold((failure) {
      _topRatedState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _topRatedState = RequestState.Loaded;
      _topRatedTvSeries = tvSeriesData;
      notifyListeners();
    });
  }

}
