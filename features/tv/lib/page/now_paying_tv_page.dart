import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/now_playing/tv_now_playing_bloc.dart';
import 'package:tv/bloc/now_playing/tv_now_playing_state.dart';
import 'package:widget/tv_card.dart';

import '../bloc/now_playing/tv_now_playing_event.dart';

class NowPlayingTvPage extends StatefulWidget {
  const NowPlayingTvPage({super.key});

  @override
  State<StatefulWidget> createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TvNowPlayingBloc>(context).add(FetchNowPlayingTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing TV')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildList()),
    );
  }
}

Widget _buildList() {
  return BlocBuilder<TvNowPlayingBloc, TvNowPlayingState>(
    builder: (context, state) {
      if (state is TvNowPlayingLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TvNowPlayingHasData) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final tv = state.nowPlaying[index];
            return TvCard(tv: tv);
          },
          itemCount: state.nowPlaying.length,
        );
      } else if (state is TvNowPlayingError) {
        return Center(
            key: const Key('error_message'), child: Text(state.message));
      } else {
        return const Center(key: Key('empty_message'), child: Text("Empty"));
      }
    },
  );
}
