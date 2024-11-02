import 'package:equatable/equatable.dart';
import 'package:model/movie/movie_detail.dart';

abstract class MovieDetailWatchlistEvent extends Equatable {
  const MovieDetailWatchlistEvent();
}

class AddToWatchlist extends MovieDetailWatchlistEvent {
  final MovieDetail movieDetail;

  const AddToWatchlist(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class RemoveWatchlist extends MovieDetailWatchlistEvent {
  final MovieDetail movieDetail;

  const RemoveWatchlist(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class CheckWatchlistStatus extends MovieDetailWatchlistEvent {
  final int id;

  const CheckWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}