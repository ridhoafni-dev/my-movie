import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_movie/common/constans.dart';
import 'package:my_movie/common/utils.dart';
import 'package:my_movie/presentation/pages/about_page.dart';
import 'package:my_movie/presentation/pages/home_movie_page.dart';
import 'package:my_movie/presentation/pages/movie_detail_page.dart';
import 'package:my_movie/presentation/pages/now_paying_tv_page.dart';
import 'package:my_movie/presentation/pages/popular_movie_page.dart';
import 'package:my_movie/presentation/pages/search_page.dart';
import 'package:my_movie/presentation/pages/top_rated_movie_page.dart';
import 'package:my_movie/presentation/pages/tv_detail_page.dart';
import 'package:my_movie/presentation/pages/watchlist_page.dart';
import 'package:my_movie/presentation/providers/movie/movie_detail_notifier.dart';
import 'package:my_movie/presentation/providers/movie/movie_list_notifier.dart';
import 'package:my_movie/presentation/providers/movie/movie_search_notifier.dart';
import 'package:my_movie/presentation/providers/movie/popular_movies_notifier.dart';
import 'package:my_movie/presentation/providers/movie/top_rated_movies_notifier.dart';
import 'package:my_movie/presentation/providers/movie/watchlist_movie_notifier.dart';
import 'package:my_movie/presentation/providers/tv/tv_detail_notifier.dart';
import 'package:my_movie/presentation/providers/tv/tv_search_notifier.dart';
import 'package:my_movie/presentation/providers/tv/tv_series_list_notifier.dart';
import 'package:my_movie/presentation/providers/tv/watchlist_tv_notifier.dart';
import 'package:provider/provider.dart';
import 'injection.dart' as di;

void main() {
  di.init();
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
            create: (_) => di.locator<TvSeriesListNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieSearchNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistMovieNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistTvNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvSearchNotifier>()), //SearchNotifier>()),
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
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case MovieDetailPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final id = args['id'] as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => const SearchPage(),
              );
            case NowPlayingTvPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const NowPlayingTvPage()
              );
            case PopularMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviePage()
              );
            case TopRatedMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviePage()
              );
            case WatchlistPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const WatchlistPage()
              );
            case AboutPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const AboutPage());
            case TvDetailPage.ROUTE_NAME:
              final args = settings.arguments as Map<String, dynamic>;
              final id = args['id'] as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
              );
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
