import 'package:domain/usecases/tv/get_popular_tv_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/state_enum.dart';

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
    }, (tvSeriesData) {
      _state = RequestState.Loaded;
      _popularTvSeries = tvSeriesData;
      notifyListeners();
    });
  }
}
