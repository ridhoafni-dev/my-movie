import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/presentation/pages/about_page.dart';
import 'package:my_movie/presentation/pages/movie_detail_page.dart';
import 'package:my_movie/presentation/pages/now_paying_tv_page.dart';
import 'package:my_movie/presentation/pages/popular_movie_page.dart';
import 'package:my_movie/presentation/pages/search_page.dart';
import 'package:my_movie/presentation/pages/top_rated_movie_page.dart';
import 'package:my_movie/presentation/pages/tv_detail_page.dart';
import 'package:my_movie/presentation/pages/watchlist_page.dart';
import 'package:my_movie/presentation/providers/tv/tv_series_list_notifier.dart';
import 'package:provider/provider.dart';

import '../../common/constans.dart';
import '../providers/movie/movie_list_notifier.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = "home";

  const HomeMoviePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final movieNotifier =
          Provider.of<MovieListNotifier>(context, listen: false);
      final tvNotifier =
          Provider.of<TvSeriesListNotifier>(context, listen: false);

      movieNotifier
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();

      tvNotifier.fetchNowPlayingTvSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: const AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: const Text('My Movie'),
              accountEmail: const Text('mymovie@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("My Movie"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSubHeading(
                title: '${MovieType.NowPlaying.description} Tv Series',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayingTvPage.ROUTE_NAME),
              ),
              _buildMovieList(MovieType.NowPlaying),
              _buildSubHeading(
                title: '${MovieType.Popular.description} Movies',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviePage.ROUTE_NAME),
              ),
              _buildMovieList(MovieType.Popular),
              _buildSubHeading(
                title: '${MovieType.TopRated.description} Movies',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviePage.ROUTE_NAME),
              ),
              _buildMovieList(MovieType.TopRated),
            ]),
          )),
    );
  }
}

Widget _buildMovieList(MovieType type) {
  return Consumer2<MovieListNotifier, TvSeriesListNotifier>(
      builder: (context, movieData, tvData, child) {
    RequestState state;
    List<Movie> movies = [];
    List<Tv> tvSeries = [];
    switch (type) {
      case MovieType.NowPlaying: // tv is now playing
        state = tvData.nowPlayingState;
        tvSeries = tvData.nowPlayingTvSeries;
        break;
      case MovieType.Popular: // tv is popular
        state = movieData.popularMoviesState;
        movies = movieData.popularMovies;
        break;
      case MovieType.TopRated: //tv is top-rated
        state = movieData.topRatedMoviesState;
        movies = movieData.topRatedMovies;
        break;
      default:
        state = RequestState.Empty;
        movies = List.empty();
        tvSeries = List.empty();
        break;
    }

    if (state == RequestState.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state == RequestState.Loaded) {
      if (type == MovieType.NowPlaying) {
        return TvList(tvSeries);
      } else {
        return MovieList(movies);
      }
    } else {
      return Center(
        key: const Key('error_message'),
        child: Text(movieData.message),
      );
    }
  });
}

Widget _buildSubHeading({required String title, Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        if (onTap != null)
          InkWell(
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Text('See More'),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

class TvList extends StatelessWidget {
  final List<Tv> tvSeries;

  const TvList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tvSeries.length,
          itemBuilder: (context, index) {
            final tv = tvSeries[index];

            return Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TvDetailPage.ROUTE_NAME,
                        arguments: {'id': tv.id},
                      );
                    },
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ))));
          },
        ));
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MovieDetailPage.ROUTE_NAME,
                        arguments: {'id': movie.id},
                      );
                    },
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ))));
          },
        ));
  }
}

enum MovieType {
  Popular('Popular'),
  NowPlaying('Now Playing'),
  TopRated('Top Rated');

  final String description;

  const MovieType(this.description);
}
