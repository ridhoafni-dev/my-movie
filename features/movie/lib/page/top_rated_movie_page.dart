import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_bloc.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_event.dart';
import 'package:movie/bloc/top_rated/movie_top_rated_state.dart';
import 'package:widget/movie_card.dart';

class TopRatedMoviePage extends StatefulWidget {
  const TopRatedMoviePage({super.key});

  @override
  State<StatefulWidget> createState() => _TopRatedMoviePageState();
}

class _TopRatedMoviePageState extends State<TopRatedMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<MovieTopRatedBloc>(context).add(FetchTopRatedMovie()));
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
  return BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
    builder: (context, state) {
      if (state is MovieTopRatedLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is MovieTopRatedHasData) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final movie = state.topRated[index];
            return MovieCard(movie: movie);
          },
          itemCount: state.topRated.length,
        );
      } else if (state is MovieTopRatedError) {
        return Center(
            key: const Key('error_message'), child: Text(state.message));
      } else {
        return const Center(child: Text("Empty Data"));
      }
    },
  );
}
