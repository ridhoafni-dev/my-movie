import 'package:equatable/equatable.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTvProgram extends TvSearchEvent {
  final String query;

  const SearchTvProgram(this.query);

  @override
  List<Object> get props => [];
}

class ClearSearchTv extends TvSearchEvent {}
