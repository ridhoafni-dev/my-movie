import 'package:domain/usecases/tv/search_tv_series.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/bloc/tv/tv_search_event.dart';
import 'package:search/bloc/tv/tv_search_state.dart';


class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvSeries _searchTvSeries;

  TvSearchBloc({
    required SearchTvSeries searchTvSeries,
  })  : _searchTvSeries = searchTvSeries,
        super(TvSearchEmpty()) {
    on<SearchTvProgram>(
      (event, emit) async {
        emit(TvSearchLoading());

        final searchData = await _searchTvSeries.execute(event.query);

        searchData.fold(
          (failure) => emit(TvSearchError(failure.message)),
          (data) => emit(TvSearchHasData(data)),
        );
      },
    );
    on<ClearSearchTv>((event, emit) => emit(TvSearchEmpty()));
  }
}
