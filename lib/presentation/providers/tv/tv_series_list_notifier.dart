import 'package:flutter/cupertino.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/usecases/tv/get_now_playing_tv_series.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  late var _nowPlayingTvSeries = <Tv>[];

  List<Tv> get nowPlayingTvSeries => _nowPlayingTvSeries;

  late RequestState _nowPlayingState = RequestState.Empty;

  RequestState get nowPlayingState => _nowPlayingState;

  String _message = '';

  String get message => _message;

  TvSeriesListNotifier({
    required this.useCaseGetNowPlayingTvSeries,
  });

  final GetNowPlayingTvSeries useCaseGetNowPlayingTvSeries;

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
}
