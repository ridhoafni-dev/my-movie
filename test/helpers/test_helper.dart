import 'package:mockito/annotations.dart';
import 'package:my_movie/data/datasources/db/database_helper.dart';
import 'package:my_movie/data/datasources/movie_local_data_source.dart';
import 'package:my_movie/data/datasources/movie_remote_data_source.dart';
import 'package:my_movie/data/datasources/tv_local_data_source.dart';
import 'package:my_movie/data/datasources/tv_remote_data_source.dart';
import 'package:my_movie/domain/repositories/movie_repository.dart';
import 'package:http/http.dart' as http;
import 'package:my_movie/domain/repositories/tv_repository.dart';

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    TvRepository,
    TvRemoteDataSource,
    TvLocalDataSource,
    DatabaseHelper,
  ], customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient)
  ]
)

void main(){}