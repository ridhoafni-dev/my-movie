import 'package:equatable/equatable.dart';
import 'package:model/tv/tv.dart';

abstract class TvTopRatedState extends Equatable {
  const TvTopRatedState();

  @override
  List<Object> get props => [];
}

class TvTopRatedEmpty extends TvTopRatedState {}

class TvTopRatedLoading extends TvTopRatedState {}

class TvTopRatedError extends TvTopRatedState {
  final String message;

  const TvTopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TvTopRatedHasData extends TvTopRatedState {
  final List<Tv> topRated;

  const TvTopRatedHasData({required this.topRated});

  @override
  List<Object> get props => [topRated];
}