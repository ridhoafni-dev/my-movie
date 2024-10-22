import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styles/text_styles.dart';
import 'package:utils/utils/state_enum.dart';
import 'package:widget/movie_card.dart';
import 'package:widget/tv_card.dart';

import '../providers/movie_search_notifier.dart';
import '../providers/tv_search_notifier.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MovieSearchNotifier>(context, listen: false).resetState();
    Provider.of<TvSearchNotifier>(context, listen: false).resetState();
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
          title: const Text('Search'),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onSubmitted: (query) {
                    Provider.of<MovieSearchNotifier>(context, listen: false)
                        .fetchMovieSearch(query);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search title',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder()),
                  textInputAction: TextInputAction.search,
                ),
                const SizedBox(height: 16),
                Text(
                  "Search Result",
                  style: kHeading6,
                ),
                Expanded(
                  child: Consumer<MovieSearchNotifier>(
                    builder: (context, movieData, child) {
                      return SearchContent(
                        state: movieData.state,
                        data: movieData.searchResult,
                        itemBuilder: (item) => MovieCard(movie: item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onSubmitted: (query) {
                    Provider.of<TvSearchNotifier>(context, listen: false)
                        .fetchTvSearch(query);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search title',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder()),
                  textInputAction: TextInputAction.search,
                ),
                const SizedBox(height: 16),
                Text(
                  "Search Result",
                  style: kHeading6,
                ),
                Expanded(
                  child: Consumer<TvSearchNotifier>(
                    builder: (context, tvData, child) {
                      return SearchContent(
                          state: tvData.state,
                          data: tvData.searchResult,
                          itemBuilder: (item) => TvCard(tv: item));
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class SearchContent extends StatelessWidget {
  final RequestState state;
  final List data;
  final Widget Function(dynamic item) itemBuilder;

  const SearchContent(
      {super.key,
      required this.state,
      required this.data,
      required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    if (state == RequestState.Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state == RequestState.Loaded) {
      return ListView.builder(
        itemBuilder: (context, index) => itemBuilder(data[index]),
        itemCount: data.length,
      );
    } else if (state == RequestState.Error) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.name),
      );
    } else {
      return const Center();
    }
  }
}
