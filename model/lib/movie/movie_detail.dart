import 'package:equatable/equatable.dart';

import '../genre/genre.dart';

class MovieDetail extends Equatable {
  const MovieDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.voteCount
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final int runtime;
  final String title;
  final double voteAverage;
  final int voteCount;

  MovieDetail copyWith({
    bool? adult,
    String? backdropPath,
    List<Genre>? genres,
    int? id,
    String? originalTitle,
    String? overview,
    String? posterPath,
    int? runtime,
    String? title,
    double? voteAverage,
    int? voteCount,
  }) =>
      MovieDetail(
        adult: adult ?? this.adult,
        backdropPath: backdropPath ?? this.backdropPath,
        genres: genres ?? this.genres,
        id: id ?? this.id,
        originalTitle: originalTitle ?? this.originalTitle,
        overview: overview ?? this.overview,
        posterPath: posterPath ?? this.posterPath,
        runtime: runtime ?? this.runtime,
        title: title ?? this.title,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalTitle,
        overview,
        posterPath,
        runtime,
        title,
        voteAverage,
        voteCount,
      ];
}
