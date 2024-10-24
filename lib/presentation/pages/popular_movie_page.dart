import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/presentation/providers/movie/popular_movies_notifier.dart';
import 'package:my_movie/presentation/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class PopularMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviePage({super.key});

  @override
  State<StatefulWidget> createState() => _PopularMoviePageState();
}

class _PopularMoviePageState extends State<PopularMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularMoviesNotifier>(context, listen: false)
            .fetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildList()),
    );
  }
}

Widget _buildList() {
  return Consumer<PopularMoviesNotifier>(
    builder: (context, data, child) {
      if (data.state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.state == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final movie = data.popularMovies[index];
            return MovieCard(movie: movie);
          },
          itemCount: data.popularMovies.length,
        );
      } else {
        return Center(
            key: const Key('error_message'),child: Text(data.message));
      }
    },
  );
}
