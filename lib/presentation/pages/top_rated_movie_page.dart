import 'package:flutter/material.dart';
import 'package:my_movie/presentation/providers/movie/top_rated_movies_notifier.dart';
import 'package:my_movie/presentation/widgets/movie_card.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils/state_enum.dart';

class TopRatedMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviePage({super.key});

  @override
  State<StatefulWidget> createState() => _TopRatedMoviePageState();
}

class _TopRatedMoviePageState extends State<TopRatedMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedMoviesNotifier>(context, listen: false)
            .fetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Movies')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildList()),
    );
  }
}

Widget _buildList() {
  return Consumer<TopRatedMoviesNotifier>(
    builder: (context, data, child) {
      if (data.state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.state == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final movie = data.topRatedMovies[index];
            return MovieCard(movie: movie);
          },
          itemCount: data.topRatedMovies.length,
        );
      } else {
        return Center(
            key: const Key('error_message'), child: Text(data.message));
      }
    },
  );
}
