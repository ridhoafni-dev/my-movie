import 'package:equatable/equatable.dart';

abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistTvSeries extends TvWatchlistEvent {}
