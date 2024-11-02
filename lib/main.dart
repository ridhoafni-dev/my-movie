import 'package:about/about_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/detail/movie_detail_bloc.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_bloc.dart';
import 'package:movie/bloc/list/movie_list_bloc.dart';
import 'package:movie/bloc/now_playing/movie_now_playing_bloc.dart';
import 'package:movie/bloc/popular/movie_popular_bloc.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_bloc.dart';
import 'package:movie/page/home_movie_page.dart';
import 'package:movie/page/movie_detail_page.dart';
import 'package:movie/page/now_paying_movies_page.dart';
import 'package:movie/page/popular_movie_page.dart';
import 'package:movie/page/top_rated_movie_page.dart';
import 'package:my_movie/http_ssl_pinning.dart';
import 'package:provider/provider.dart';
import 'package:search/bloc/movie/movie_search_bloc.dart';
import 'package:search/bloc/tv/tv_search_bloc.dart';
import 'package:search/pages/search_page.dart';
import 'package:styles/colors.dart';
import 'package:styles/text_styles.dart';
import 'package:tv/bloc/detail/tv_detail_bloc.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_bloc.dart';
import 'package:tv/bloc/list/tv_list_bloc.dart';
import 'package:tv/bloc/now_playing/tv_now_playing_bloc.dart';
import 'package:tv/bloc/popular/tv_popular_bloc.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_bloc.dart';
import 'package:tv/page/now_paying_tv_page.dart';
import 'package:tv/page/popular_tv_page.dart';
import 'package:tv/page/top_rated_tv_page.dart';
import 'package:tv/page/tv_detail_page.dart';
import 'package:tv/page/tv_series_list_page.dart';
import 'package:utils/utils.dart';
import 'package:watchlist/bloc/movie/movie_watchlist_bloc.dart';
import 'package:watchlist/bloc/tv/tv_watchlist_bloc.dart';
import 'package:watchlist/page/watchlist_page.dart';

import 'firebase_options.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HttpSSLPinning.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //region bloc

        BlocProvider<MovieListBloc>(
          create: (context) => di.locator<MovieListBloc>(),
        ),
        BlocProvider<MovieDetailBloc>(
          create: (context) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider<MovieDetailWatchlistBloc>(
            create: (context) => di.locator<MovieDetailWatchlistBloc>()),

        BlocProvider<MoviePopularBloc>(
            create: (context) => di.locator<MoviePopularBloc>()),

        BlocProvider<MovieTopRatedBloc>(
            create: (context) => di.locator<MovieTopRatedBloc>()),

        BlocProvider<MovieNowPlayingBloc>(
            create: (context) => di.locator<MovieNowPlayingBloc>()),

        BlocProvider<MovieSearchBloc>(
            create: (context) => di.locator<MovieSearchBloc>()),

        BlocProvider<TvSearchBloc>(
            create: (context) => di.locator<TvSearchBloc>()),

        BlocProvider<MovieWatchlistBloc>(
            create: (context) => di.locator<MovieWatchlistBloc>()),

        BlocProvider<TvWatchlistBloc>(
            create: (context) => di.locator<TvWatchlistBloc>()),

        BlocProvider<TvTopRatedBloc>(
            create: (context) => di.locator<TvTopRatedBloc>()),
        BlocProvider<TvPopularBloc>(
            create: (context) => di.locator<TvPopularBloc>()),
        BlocProvider<TvNowPlayingBloc>(
            create: (context) => di.locator<TvNowPlayingBloc>()),
        BlocProvider<TvListBloc>(create: (context) => di.locator<TvListBloc>()),
        BlocProvider<TvDetailWatchlistBloc>(
            create: (context) => di.locator<TvDetailWatchlistBloc>()),
        BlocProvider<TvDetailBloc>(
            create: (context) => di.locator<TvDetailBloc>()),

        //endregion
      ],
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HOME_ROUTE:
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case NOW_PLAYING_MOVIES_ROUTE:
              return MaterialPageRoute(
                  builder: (_) => const NowPlayingMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final args = settings.arguments as Map<String, dynamic>;
              final id = args['id'] as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
              );
            case SEARCH_ROUTE:
              return CupertinoPageRoute(
                builder: (_) => const SearchPage(),
              );
            case NOW_PLAYING_TV_SERIES_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const NowPlayingTvPage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviePage());
            case TOP_RATED_MOVIES_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviePage());
            case WATCHLIST_ROUTE:
              return CupertinoPageRoute(builder: (_) => const WatchlistPage());
            case ABOUT_ROUTE:
              return CupertinoPageRoute(builder: (_) => const AboutPage());
            case TV_DETAIL_ROUTE:
              final args = settings.arguments as Map<String, dynamic>;
              final id = args['id'] as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
              );
            case TV_SERIES_LIST_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const TvSeriesListPage());
            case POPULAR_TV_SERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => const PopularTvPage());
            case TOP_RATED_TV_SERIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => const TopRatedTvPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Text('Page not found :(');
              });
          }
        },
      ),
    );
  }
}
