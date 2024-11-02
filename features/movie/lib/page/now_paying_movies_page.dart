import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/now_playing/movie_now_playing_bloc.dart';
import 'package:movie/bloc/now_playing/movie_now_playing_event.dart';
import 'package:movie/bloc/now_playing/movie_now_playing_state.dart';
import 'package:widget/movie_card.dart';

class NowPlayingMoviesPage extends StatefulWidget {
  const NowPlayingMoviesPage({super.key});

  @override
  State<StatefulWidget> createState() => _NowPlayingMoviesPageState();
}

class _NowPlayingMoviesPageState extends State<NowPlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<MovieNowPlayingBloc>(context)
        .add(FetchNowPlayingMovie()));
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
  return BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
    builder: (context, state) {
      if (state is MovieNowPlayingLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is MovieNowPlayingHasData) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final movie = state.nowPlaying[index];
            return MovieCard(movie: movie);
          },
          itemCount: state.nowPlaying.length,
        );
      } else if (state is MovieNowPlayingError) {
        return Center(
            key: const Key('error_message'), child: Text(state.message));
      } else {
        return const Center(child: Text('Empty Data'));
      }
    },
  );
}
