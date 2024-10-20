import 'package:flutter/cupertino.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entity/tv/tv.dart';
import '../../../domain/usecases/tv/get_top_rated_series.dart';

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
