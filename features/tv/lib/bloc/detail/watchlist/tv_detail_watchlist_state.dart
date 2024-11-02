import 'package:equatable/equatable.dart';

abstract class TvDetailWatchlistState extends Equatable {

  const TvDetailWatchlistState();

  @override
  List<Object> get props => [];

}

class AlreadyOnWatchlist extends TvDetailWatchlistState {}

class NotOnWatchlist extends TvDetailWatchlistState {}

class UpdatingWatchlist extends TvDetailWatchlistState {}

class WatchlistError extends TvDetailWatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}