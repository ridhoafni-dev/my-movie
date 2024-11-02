import 'package:equatable/equatable.dart';
import 'package:model/tv/tv.dart';
import 'package:model/tv/tv_detail.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;

  const TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail tv;
  final List<Tv> recommendations;

  const TvDetailHasData({required this.tv, required this.recommendations});

  @override
  List<Object> get props => [Tv, recommendations];
}
