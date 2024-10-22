import 'package:domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/state_enum.dart';

class TopRatedTvSeriesNotifier extends ChangeNotifier {
  late final GetTopRatedTvSeries useCaseGetTopRatedTvSeries;

  TopRatedTvSeriesNotifier({required this.useCaseGetTopRatedTvSeries});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _topRatedTvSeries = [];

  List<Tv> get topRatedTvSeries => _topRatedTvSeries;

  String _message = '';

  String get message => _message;

  Future<void> fetchTopRatedTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetTopRatedTvSeries.execute();
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _state = RequestState.Loaded;
      _topRatedTvSeries = tvSeriesData;
      notifyListeners();
    });
  }
}
