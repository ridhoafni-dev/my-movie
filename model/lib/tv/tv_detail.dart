import 'package:equatable/equatable.dart';

import '../genre/genre.dart';

class TvDetail extends Equatable {
  const TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.name,
    required this.voteAverage,
    required this.voteCount
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalName;
  final String overview;
  final String posterPath;
  final String name;
  final double voteAverage;
  final int voteCount;

  TvDetail copyWith({
    bool? adult,
    String? backdropPath,
    List<Genre>? genres,
    int? id,
    String? originalName,
    String? overview,
    String? posterPath,
    String? name,
    double? voteAverage,
    int? voteCount,
  }) =>
      TvDetail(
        adult: adult ?? this.adult,
        backdropPath: backdropPath ?? this.backdropPath,
        genres: genres ?? this.genres,
        id: id ?? this.id,
        originalName: this.originalName,
        overview: overview ?? this.overview,
        posterPath: posterPath ?? this.posterPath,
        name: name ?? this.name,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalName,
        overview,
        posterPath,
        name,
        voteAverage,
        voteCount,
      ];
}
