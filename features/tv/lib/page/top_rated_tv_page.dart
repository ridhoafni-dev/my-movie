import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_bloc.dart';
import 'package:tv/bloc/top_rated/tv_top_rated_state.dart';
import 'package:widget/tv_card.dart';

import '../bloc/top_rated/tv_top_rated_event.dart';

class TopRatedTvPage extends StatefulWidget {
  const TopRatedTvPage({super.key});

  @override
  State<StatefulWidget> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<TvTopRatedBloc>(context).add(FetchTopRatedTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Tv Series')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildList()),
    );
  }
}

Widget _buildList() {
  return BlocBuilder<TvTopRatedBloc, TvTopRatedState>(
    builder: (context, state) {
      if (state is TvTopRatedLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TvTopRatedHasData) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final tv = state.topRated[index];
            return TvCard(tv: tv);
          },
          itemCount: state.topRated.length,
        );
      } else if (state is TvTopRatedError) {
        return Center(
            key: const Key('error_message'), child: Text(state.message));
      } else {
        return const Center(child: Text("Empty Data"));
      }
    },
  );
}
