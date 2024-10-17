import 'package:equatable/equatable.dart';
import 'package:my_movie/data/model/genre_model.dart';

import '../../../domain/entity/movie/movie_detail.dart';
class MovieDetailResponse extends Equatable {
  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final int runtime;
  final String status;
  final String tagline;
  final String title;
  final double voteAverage;
  final int voteCount;

  const MovieDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) =>
      MovieDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        runtime: json["episode_run_time"],
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "original_language": originalLanguage,
        "original_name": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "episode_run_time": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  MovieDetail toEntity() {
    return MovieDetail(
      adult: adult,
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: posterPath,
      runtime: runtime,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        homepage,
        id,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        runtime,
        status,
        tagline,
        title,
        voteAverage,
        voteCount,
      ];
}
