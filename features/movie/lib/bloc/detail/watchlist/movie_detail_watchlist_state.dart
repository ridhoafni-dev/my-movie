import 'package:equatable/equatable.dart';

abstract class MovieDetailWatchlistState extends Equatable {

  const MovieDetailWatchlistState();

  @override
  List<Object> get props => [];

}

class AlreadyOnWatchlist extends MovieDetailWatchlistState {}

class NotOnWatchlist extends MovieDetailWatchlistState {}

class UpdatingWatchlist extends MovieDetailWatchlistState {}

class WatchlistError extends MovieDetailWatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}