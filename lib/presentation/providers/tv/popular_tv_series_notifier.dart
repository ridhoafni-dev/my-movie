import 'package:flutter/cupertino.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entity/tv/tv.dart';
import '../../../domain/usecases/tv/get_popular_tv_series.dart';

class PopularTvSeriesNotifier extends ChangeNotifier {
  late final GetPopularTvSeries useCaseGetPopularTvSeries;

  PopularTvSeriesNotifier({required this.useCaseGetPopularTvSeries});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _popularTvSeries = [];

  List<Tv> get popularTvSeries => _popularTvSeries;

  String _message = '';

  String get message => _message;

  Future<void> fetchPopularTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetPopularTvSeries.execute();
    result.fold((failure) {
      _state = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (TvSeriesData) {
      _state = RequestState.Loaded;
      _popularTvSeries = TvSeriesData;
      notifyListeners();
    });
  }
}
