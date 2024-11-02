import 'package:equatable/equatable.dart';
import 'package:model/tv/tv.dart';

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object> get props => [];
}

class TvSearchEmpty extends TvSearchState {}

class TvSearchLoading extends TvSearchState {}

class TvSearchError extends TvSearchState {
  final String message;

  const TvSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSearchHasData extends TvSearchState {
  final List<Tv> searchResult;

  const TvSearchHasData(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}
