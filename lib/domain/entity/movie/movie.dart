import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.video,
    required this.title,
    required this.voteAverage,
    required this.voteCount
  });

  Movie.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title
  });

  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  bool? video;
  String? title;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        video,
        title,
        voteAverage,
        voteCount,
      ];
}
