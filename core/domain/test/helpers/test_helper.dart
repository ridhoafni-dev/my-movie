import 'package:domain/repositories/movie_repository.dart';
import 'package:domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    MovieRepository,
    TvRepository,
  ], customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient)
  ]
)

void main(){}