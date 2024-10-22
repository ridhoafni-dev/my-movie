import 'package:about/about_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/page/home_movie_page.dart';
import 'package:movie/page/movie_detail_page.dart';
import 'package:movie/page/now_paying_movies_page.dart';
import 'package:movie/page/popular_movie_page.dart';
import 'package:movie/page/top_rated_movie_page.dart';
import 'package:movie/provider/movie_detail_notifier.dart';
import 'package:movie/provider/movie_list_notifier.dart';
import 'package:movie/provider/movie_search_notifier.dart';
import 'package:movie/provider/now_playing_movies_notifier.dart';
import 'package:movie/provider/popular_movies_notifier.dart';
import 'package:movie/provider/top_rated_movies_notifier.dart';
import 'package:provider/provider.dart';
import 'package:search/pages/search_page.dart';
import 'package:search/providers/tv_search_notifier.dart';
import 'package:styles/colors.dart';
import 'package:styles/text_styles.dart';
import 'package:tv/page/now_paying_tv_page.dart';
import 'package:tv/page/popular_tv_page.dart';
import 'package:tv/page/top_rated_tv_page.dart';
import 'package:tv/page/tv_detail_page.dart';
import 'package:tv/page/tv_series_list_page.dart';
import 'package:tv/provider/now_playing_tv_series_notifier.dart';
import 'package:tv/provider/popular_tv_series_notifier.dart';
import 'package:tv/provider/top_rated_tv_series_notifier.dart';
import 'package:tv/provider/tv_detail_notifier.dart';
import 'package:tv/provider/tv_series_list_notifier.dart';
import 'package:utils/utils.dart';
import 'package:watchlist/page/watchlist_page.dart';
import 'package:watchlist/provider/watchlist_movie_notifier.dart';
import 'package:watchlist/provider/watchlist_tv_notifier.dart';

import 'injection.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieSearchNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<NowPlayingMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistMovieNotifier>()),

        ChangeNotifierProvider(
            create: (_) => di.locator<NowPlayingTvSeriesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularTvSeriesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedTvSeriesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvSeriesListNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TvDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistTvNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TvSearchNotifier>()),
        //SearchNotifier>()),
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
