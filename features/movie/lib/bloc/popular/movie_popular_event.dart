import 'package:equatable/equatable.dart';

abstract class MoviePopularEvent extends Equatable {
  const MoviePopularEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovie extends MoviePopularEvent {}
