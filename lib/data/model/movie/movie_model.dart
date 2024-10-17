import 'package:equatable/equatable.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';

class MovieModel extends Equatable {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final bool? video;
  final String title;
  final double voteAverage;
  final int voteCount;

  const MovieModel({
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

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      MovieModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        video: json["video"],
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "video": video,
        "title": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Movie toEntity() => Movie(
        adult: adult,
        backdropPath: backdropPath,
        genreIds: genreIds,
        id: id,
        originalTitle: originalTitle,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        releaseDate: releaseDate,
        video: video,
        title: title,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

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
        voteCount
      ];
}
