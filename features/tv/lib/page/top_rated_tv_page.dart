import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils/state_enum.dart';
import 'package:widget/tv_card.dart';

import '../provider/top_rated_tv_series_notifier.dart';

class TopRatedTvPage extends StatefulWidget {
  const TopRatedTvPage({super.key});

  @override
  State<StatefulWidget> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTvSeriesNotifier>(context, listen: false)
            .fetchTopRatedTvSeries());
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
  return Consumer<TopRatedTvSeriesNotifier>(
    builder: (context, data, child) {
      if (data.state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.state == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final tv = data.topRatedTvSeries[index];
            return TvCard(tv: tv);
          },
          itemCount: data.topRatedTvSeries.length,
        );
      } else {
        return Center(
            key: const Key('error_message'), child: Text(data.message));
      }
    },
  );
}