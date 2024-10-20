import 'package:data/datasources/db/database_helper.dart';
import 'package:data/datasources/movie/movie_local_data_source.dart';
import 'package:data/datasources/movie/movie_remote_data_source.dart';
import 'package:data/datasources/tv/tv_local_data_source.dart';
import 'package:data/datasources/tv/tv_remote_data_source.dart';
import 'package:domain/repositories/movie_repository.dart';
import 'package:domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

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