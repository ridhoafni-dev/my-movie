import 'package:equatable/equatable.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/entity/tv/tv_detail.dart';

class TvTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  const TvTable(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview});

  factory TvTable.fromEntity(TvDetail movie) => TvTable(
      id: movie.id,
      title: movie.name,
      posterPath: movie.posterPath,
      overview: movie.overview,
  );

  factory TvTable.fromMap(Map<String, dynamic> map) =>
      TvTable(
          id: map['id'],
          title: map['title'],
          posterPath: map['posterPath'],
          overview: map['overview']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
      };

  Tv toEntity() => Tv.watchlist(
        id: id,
        name: title,
        posterPath: posterPath,
        overview: overview,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview];
}
