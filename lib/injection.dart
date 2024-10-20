import 'package:data/datasources/db/database_helper.dart';
import 'package:data/datasources/movie/movie_local_data_source.dart';
import 'package:data/datasources/movie/movie_remote_data_source.dart';
import 'package:data/datasources/tv/tv_local_data_source.dart';
import 'package:data/datasources/tv/tv_remote_data_source.dart';
import 'package:data/repositories/movie_repository_impl.dart';
import 'package:data/repositories/tv_repository_impl.dart';
import 'package:domain/repositories/movie_repository.dart';
import 'package:domain/repositories/tv_repository.dart';
import 'package:domain/usecases/movie/get_movie_detail.dart';
import 'package:domain/usecases/movie/get_movie_recommendations.dart';
import 'package:domain/usecases/movie/get_movie_watchlist_status.dart';
import 'package:domain/usecases/movie/get_popular_movies.dart';
import 'package:domain/usecases/movie/get_top_rated_movies.dart';
import 'package:domain/usecases/movie/get_watchlist_movies.dart';
import 'package:domain/usecases/movie/remove_movie_watchlist.dart';
import 'package:domain/usecases/movie/save_movie_watchlist.dart';
import 'package:domain/usecases/movie/search_movies.dart';
import 'package:domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:domain/usecases/tv/get_tv_detail.dart';
import 'package:domain/usecases/tv/get_tv_recommendations.dart';
import 'package:domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:domain/usecases/tv/save_tv_watchlist.dart';
import 'package:domain/usecases/tv/search_tv_series.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:my_movie/presentation/providers/movie/movie_detail_notifier.dart';
import 'package:my_movie/presentation/providers/movie/movie_list_notifier.dart';
import 'package:my_movie/presentation/providers/movie/popular_movies_notifier.dart';
import 'package:my_movie/presentation/providers/movie/top_rated_movies_notifier.dart';
import 'package:my_movie/presentation/providers/movie/watchlist_movie_notifier.dart';
import 'package:my_movie/presentation/providers/tv/tv_detail_notifier.dart';
import 'package:my_movie/presentation/providers/tv/tv_series_list_notifier.dart';
import 'package:my_movie/presentation/providers/tv/watchlist_tv_notifier.dart';
import 'package:search/presentation/providers/movie_search_notifier.dart';
import 'package:search/presentation/providers/tv_search_notifier.dart';

final locator = GetIt.instance;

Future<void> init() async {

  // provider
  locator.registerFactory(() => MovieListNotifier(
    getTopRatedMovies: locator(),
    getPopularMovies: locator(),
  ));
  locator.registerFactory(() => WatchlistMovieNotifier(
    useCaseGetWatchlistMovies: locator(),
  ));
  locator.registerFactory(() => PopularMoviesNotifier(
    useCaseGetPopularMovies: locator(),
  ));
  locator.registerFactory(() => TopRatedMoviesNotifier(
    useCaseGetTopRatedMovies: locator(),
  ));
  locator.registerFactory(() => MovieDetailNotifier(
    useCaseGetMovieDetail: locator(),
    useCaseGetMovieRecommendations: locator(),
    useCaseGetWatchListStatus: locator(),
    useCaseSaveWatchlist: locator(),
    useCaseRemoveWatchlist: locator(),
  ));
  locator.registerFactory(
          () => MovieSearchNotifier(useCaseGetSearchMovies: locator()));

  locator.registerFactory(
          () => TvSeriesListNotifier(useCaseGetNowPlayingTvSeries: locator()));
  locator.registerFactory(() => TvDetailNotifier(
    useCaseGetTvDetail: locator(),
    useCaseGetTvRecommendations: locator(),
    useCaseGetTvWatchlistStatus: locator(),
    useCaseSaveWatchlist: locator(),
    useCaseRemoveWatchlist: locator(),
  ));
  locator.registerFactory(
          () => WatchlistTvNotifier(useCaseGetWatchlistTvSeries: locator()));
  locator.registerFactory(
          () => TvSearchNotifier(useCaseGetSearchTvSeries: locator()));

  // use case
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));

  locator.registerLazySingleton(() => GetMovieWatchListStatus(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
      movieRemoteDataSource: locator(), movieLocalDataSource: locator()));
  locator.registerLazySingleton<TvRepository>(() => TvRepositoryImpl(
      tvRemoteDataSource: locator(), tvLocalDataSource: locator()));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
          () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
          () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());

}
