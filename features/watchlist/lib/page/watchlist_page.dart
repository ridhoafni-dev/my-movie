import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model/movie/movie.dart';
import 'package:model/tv/tv.dart';
import 'package:utils/utils/utils.dart';
import 'package:widget/movie_card.dart';
import 'package:widget/tv_card.dart';

import '../bloc/movie/movie_watchlist_bloc.dart';
import '../bloc/movie/movie_watchlist_event.dart';
import '../bloc/movie/movie_watchlist_state.dart';
import '../bloc/tv/tv_watchlist_bloc.dart';
import '../bloc/tv/tv_watchlist_event.dart';
import '../bloc/tv/tv_watchlist_state.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<StatefulWidget> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvWatchlistBloc>(context).add(LoadWatchlistTvSeries());
      BlocProvider.of<MovieWatchlistBloc>(context).add(LoadWatchlistMovies());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    BlocProvider.of<TvWatchlistBloc>(context).add(LoadWatchlistTvSeries());
    BlocProvider.of<MovieWatchlistBloc>(context).add(LoadWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(dividerColor: Colors.black, tabs: [
            Tab(text: "Movies"),
            Tab(text: "TV Series"),
          ]),
          title: const Text("Watchlist"),
        ),
        body: TabBarView(children: [
          buildSearchTab(context, isMovie: true),
          buildSearchTab(context, isMovie: false),
        ]),
      ),
    );
  }
}

Widget buildSearchTab(BuildContext context, {required bool isMovie}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isMovie
          ? Column(
              children: [
                Expanded(
                    child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
                  builder: (context, state) {
                    return buildSearchContent(state, isMovie);
                  },
                )),
              ],
            )
          : Column(
              children: [
                Expanded(child: BlocBuilder<TvWatchlistBloc, TvWatchlistState>(
                  builder: (context, state) {
                    return buildSearchContent(state, isMovie);
                  },
                )),
              ],
            ));
}

Widget buildSearchContent(dynamic state, bool isMovie) {
  if (state is MovieWatchlistLoading || state is TvWatchlistLoading) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is MovieWatchlistHasData || state is TvWatchlistHasData) {
    final watchlist = isMovie
        ? (state as MovieWatchlistHasData).watchlist
        : (state as TvWatchlistHasData).watchlist;

    return ListView.builder(
        itemBuilder: (context, index) => isMovie
            ? MovieCard(movie: watchlist[index] as Movie)
            : TvCard(tv: watchlist[index] as Tv),
        itemCount: watchlist.length);
  } else if (state is MovieWatchlistError || state is TvWatchlistError) {
    return Center(
      key: const Key('error_message'),
      child: Text(state.message),
    );
  } else {
    return const Center(
      key: Key('empty_message'),
      child: Text("Data Not found"),
    );
  }
}
