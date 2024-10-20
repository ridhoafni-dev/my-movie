import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_movie/presentation/providers/tv/popular_tv_series_notifier.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
import '../../widgets/tv_card.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTvPage({super.key});

  @override
  State<StatefulWidget> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularTvSeriesNotifier>(context, listen: false)
            .fetchPopularTvSeries()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Tv Series')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildList()),
    );
  }
}

Widget _buildList() {
  return Consumer<PopularTvSeriesNotifier>(
    builder: (context, data, child) {
      if (data.state == RequestState.Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.state == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final tv = data.popularTvSeries[index];
            return TvCard(tv: tv);
          },
          itemCount: data.popularTvSeries.length,
        );
      } else {
        return Center(
            key: const Key('error_message'),child: Text(data.message));
      }
    },
  );
}
