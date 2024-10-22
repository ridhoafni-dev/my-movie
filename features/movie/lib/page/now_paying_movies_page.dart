import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils/state_enum.dart';
import 'package:widget/movie_card.dart';

import '../provider/now_playing_movies_notifier.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  const NowPlayingMoviesPage({super.key});

  @override
  State<StatefulWidget> createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NowPlayingMoviesNotifier>(listen: false, context)
            .fetchNowPlayingMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing Movies')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildList()),
    );
  }
}

Widget _buildList() {
  return Consumer<NowPlayingMoviesNotifier>(
    builder: (context, data, child) {
      if (data.state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.state == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final movie = data.nowPlayingMovies[index];
            return MovieCard(movie: movie);
          },
          itemCount: data.nowPlayingMovies.length,
        );
      } else {
        return Center(
            key: const Key('error_message'), child: Text(data.message));
      }
    },
  );
}
