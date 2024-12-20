import 'package:entity/movie_table.dart';
import 'package:entity/tv_table.dart';
import 'package:model/genre/genre.dart';
import 'package:model/movie/movie.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:model/tv/tv.dart';
import 'package:model/tv/tv_detail.dart';

const testMovieTable = MovieTable(
    id: 1, title: "title", posterPath: "posterPath", overview: "overview");

const testTvTable = TvTable(
    id: 1, title: "name", posterPath: "posterPath", overview: "overview");

const testInsertTvTable = TvTable(
    id: 1, title: "title", posterPath: "posterPath", overview: "overview");

const testRemoveTvTable = TvTable(
    id: 1, title: "title", posterPath: "posterPath", overview: "overview");

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};


final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

const testTvDetail = TvDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  name: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
  'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
  video: false,
);

final testTvSeries = Tv(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalName: 'Spider-Man',
  overview:
  'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  name: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testTvList = [testTvSeries];

