import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils/state_enum.dart';
import 'package:widget/tv_card.dart';

import '../provider/now_playing_tv_series_notifier.dart';

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
        Provider.of<NowPlayingTvSeriesNotifier>(listen: false, context)
            .fetchNowPlayingTvSeries());
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
  return Consumer<NowPlayingTvSeriesNotifier>(
    builder: (context, data, child) {
      if (data.state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.state == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final tv = data.nowPlayingTvSeries[index];
            return TvCard(tv: tv);
          },
          itemCount: data.nowPlayingTvSeries.length,
        );
      } else {
        return Center(
            key: const Key('error_message'), child: Text(data.message));
      }
    },
  );
}