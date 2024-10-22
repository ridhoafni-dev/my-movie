import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:model/movie/movie.dart';
import 'package:provider/provider.dart';
import 'package:styles/text_styles.dart';
import 'package:utils/utils.dart';

import '../provider/movie_list_notifier.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
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
              leading: const Icon(Icons.tv),
              title: const Text('Tv Series'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, TV_SERIES_LIST_ROUTE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
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
              Navigator.pushNamed(context, SEARCH_ROUTE);
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
                title: '${MovieType.NowPlaying.description} Movies',
                onTap: () =>
                    Navigator.pushNamed(context, NOW_PLAYING_MOVIES_ROUTE),
              ),
              _buildMovieList(MovieType.NowPlaying),
              _buildSubHeading(
                title: '${MovieType.Popular.description} Movies',
                onTap: () => Navigator.pushNamed(context, POPULAR_MOVIES_ROUTE),
              ),
              _buildMovieList(MovieType.Popular),
              _buildSubHeading(
                title: '${MovieType.TopRated.description} Movies',
                onTap: () =>
                    Navigator.pushNamed(context, TOP_RATED_MOVIES_ROUTE),
              ),
              _buildMovieList(MovieType.TopRated),
            ]),
          )),
    );
  }
}

Widget _buildMovieList(MovieType type) {
  return Consumer<MovieListNotifier>(builder: (context, movieData, child) {
    RequestState state;
    List<Movie> movies = [];
    switch (type) {
      case MovieType.NowPlaying: // tv is now playing
        state = movieData.nowPlayingMoviesState;
        movies = movieData.nowPlayingMovies;
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
        break;
    }

    if (state == RequestState.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state == RequestState.Loaded) {
      return MovieList(movies);
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
                        MOVIE_DETAIL_ROUTE,
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
