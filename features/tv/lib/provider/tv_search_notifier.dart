import 'package:domain/usecases/tv/search_tv_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/state_enum.dart';

class TvSearchNotifier extends ChangeNotifier {
  final SearchTvSeries useCaseGetSearchTvSeries;

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _searchResult = [];

  List<Tv> get searchResult => _searchResult;

  String _message = '';

  String get message => _message;

  TvSearchNotifier({required this.useCaseGetSearchTvSeries});

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await useCaseGetSearchTvSeries.execute(query);
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
