import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/popular/tv_popular_bloc.dart';
import 'package:tv/bloc/popular/tv_popular_state.dart';
import 'package:widget/tv_card.dart';

import '../bloc/popular/tv_popular_event.dart';

class PopularTvPage extends StatefulWidget {
  const PopularTvPage({super.key});

  @override
  State<StatefulWidget> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<TvPopularBloc>(context).add(FetchPopularTv()));
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
  return BlocBuilder<TvPopularBloc, TvPopularState>(
    builder: (context, state) {
      if (state is TvPopularLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TvPopularHasData) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final tv = state.popular[index];
            return TvCard(tv: tv);
          },
          itemCount: state.popular.length,
        );
      } else if (state is TvPopularError) {
        return Center(
            key: const Key('error_message'), child: Text(state.message));
      } else {
        return const Center(key: Key('empty_message'), child: Text("Empty"));
      }
    },
  );
}
