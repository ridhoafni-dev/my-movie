import 'package:equatable/equatable.dart';

abstract class TvNowPlayingEvent extends Equatable {
  const TvNowPlayingEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTv extends TvNowPlayingEvent {}
