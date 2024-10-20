import 'package:flutter/material.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/presentation/providers/tv/tv_series_list_notifier.dart';
import 'package:provider/provider.dart';

import '../widgets/tv_card.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';

  const NowPlayingTvPage({super.key});

  @override
  State<StatefulWidget> createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvSeriesListNotifier>(listen: false, context)
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
  return Consumer<TvSeriesListNotifier>(
    builder: (context, data, child) {
      if (data.nowPlayingState == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.nowPlayingState == RequestState.Loaded) {
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
