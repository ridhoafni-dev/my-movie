import 'package:equatable/equatable.dart';
import 'package:my_movie/domain/entity/genre.dart';

class GenreModel extends Equatable {
  final int id;
  final String name;

  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  Genre toEntity() {
    return Genre(id: id, name: name);
  }

  @override
  List<Object?> get props => [id, name];
}
