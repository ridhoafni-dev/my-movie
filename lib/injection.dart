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
import 'package:domain/usecases/movie/get_now_playing_movies.dart';
import 'package:domain/usecases/movie/get_popular_movies.dart';
import 'package:domain/usecases/movie/get_top_rated_movies.dart';
import 'package:domain/usecases/movie/get_watchlist_movies.dart';
import 'package:domain/usecases/movie/remove_movie_watchlist.dart';
import 'package:domain/usecases/movie/save_movie_watchlist.dart';
import 'package:domain/usecases/movie/search_movies.dart';
import 'package:domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:domain/usecases/tv/get_popular_tv_series.dart';
import 'package:domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:domain/usecases/tv/get_tv_detail.dart';
import 'package:domain/usecases/tv/get_tv_recommendations.dart';
import 'package:domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:domain/usecases/tv/save_tv_watchlist.dart';
import 'package:domain/usecases/tv/search_tv_series.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/bloc/detail/movie_detail_bloc.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_bloc.dart';
import 'package:movie/bloc/list/movie_list_bloc.dart';
import 'package:movie/bloc/now_playing/movie_now_playing_bloc.dart';
import 'package:movie/bloc/popular/movie_popular_bloc.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_bloc.dart';
import 'package:my_movie/http_ssl_pinning.dart';
import 'package:search/bloc/movie/movie_search_bloc.dart';
import 'package:search/bloc/tv/tv_search_bloc.dart';
import 'package:tv/bloc/detail/tv_detail_bloc.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_bloc.dart';
import 'package:tv/bloc/list/tv_list_bloc.dart';
import 'package:tv/bloc/now_playing/tv_now_playing_bloc.dart';
import 'package:tv/bloc/popular/tv_popular_bloc.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_bloc.dart';
import 'package:watchlist/bloc/movie/movie_watchlist_bloc.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  //region bloc

  locator.registerFactory(() => MovieListBloc(
        getTopRatedMovies: locator(),
        getPopularMovies: locator(),
        getNowPlayingMovies: locator(),
      ));

  locator.registerFactory(() => MovieDetailBloc(
      getMovieDetail: locator(), getMovieRecommendations: locator()));

  locator.registerFactory(() => MovieDetailWatchlistBloc(
      getWatchlistStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));

  locator.registerFactory(() => MoviePopularBloc(getPopularMovies: locator()));

  locator.registerFactory(
      () => MovieNowPlayingBloc(getNowPlayingMovies: locator()));

  locator
      .registerFactory(() => MovieTopRatedBloc(getTopRatedMovies: locator()));

  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));

  locator.registerFactory(() => TvSearchBloc(searchTvSeries: locator()));

  locator
      .registerFactory(() => TvWatchlistBloc(getWatchlistTvSeries: locator()));

  locator
      .registerFactory(() => MovieWatchlistBloc(getWatchlistMovies: locator()));

  locator.registerFactory(() =>
      TvListBloc(getNowPlayingTvSeries: locator(), getPopularTvSeries: locator(), getTopRatedTvSeries: locator()));

  locator.registerFactory(() =>
      TvDetailBloc(getTvDetail: locator(), getTvRecommendations: locator()));

  locator.registerFactory(() => TvTopRatedBloc(getTopRatedTvSeries: locator()));

  locator.registerFactory(() => TvPopularBloc(getPopularTvSeries: locator()));

  locator.registerFactory(
      () => TvNowPlayingBloc(getNowPlayingTvSeries: locator()));

  locator.registerFactory(() => TvDetailWatchlistBloc(
      getWatchlistStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));

  //end

  // use case
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));

  locator.registerLazySingleton(() => GetMovieWatchListStatus(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
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
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
