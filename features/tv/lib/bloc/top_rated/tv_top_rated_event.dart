import 'package:equatable/equatable.dart';

abstract class TvTopRatedEvent extends Equatable {
  const TvTopRatedEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTv extends TvTopRatedEvent {}
