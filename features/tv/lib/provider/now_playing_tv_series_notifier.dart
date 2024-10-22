import 'package:domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/state_enum.dart';

class NowPlayingTvSeriesNotifier extends ChangeNotifier {
  late final GetNowPlayingTvSeries useCaseGetNowPlayingTvSeries;

  NowPlayingTvSeriesNotifier({required this.useCaseGetNowPlayingTvSeries});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _nowPlayingTvSeries = [];

  List<Tv> get nowPlayingTvSeries => _nowPlayingTvSeries;

  String _message = '';

  String get message => _message;

  Future<void> fetchNowPlayingTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetNowPlayingTvSeries.execute();
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _state = RequestState.Loaded;
      _nowPlayingTvSeries = tvSeriesData;
      notifyListeners();
    });
  }
}
