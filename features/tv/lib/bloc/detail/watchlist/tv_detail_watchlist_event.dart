import 'package:equatable/equatable.dart';
import 'package:model/tv/tv_detail.dart';

abstract class TvDetailWatchlistEvent extends Equatable {
  const TvDetailWatchlistEvent();
}

class AddToWatchlist extends TvDetailWatchlistEvent {
  final TvDetail tvDetail;

  const AddToWatchlist(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class RemoveWatchlist extends TvDetailWatchlistEvent {
  final TvDetail tvDetail;

  const RemoveWatchlist(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class CheckWatchlistStatus extends TvDetailWatchlistEvent {
  final int id;

  const CheckWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}