import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model/movie/movie.dart';
import 'package:model/tv/tv.dart';
import 'package:search/bloc/movie/movie_search_state.dart';
import 'package:search/bloc/tv/tv_search_bloc.dart';
import 'package:search/bloc/tv/tv_search_event.dart';
import 'package:styles/text_styles.dart';
import 'package:widget/movie_card.dart';
import 'package:widget/tv_card.dart';

import '../bloc/movie/movie_search_bloc.dart';
import '../bloc/movie/movie_search_event.dart';
import '../bloc/tv/tv_search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<MovieSearchBloc>(context).add(ClearSearchMovie());
    BlocProvider.of<TvSearchBloc>(context, listen: false).add(ClearSearchTv());
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onSubmitted: (query) {
            if (isMovie) {
              BlocProvider.of<MovieSearchBloc>(context).add(SearchMovie(query));
            } else {
              BlocProvider.of<TvSearchBloc>(context)
                  .add(SearchTvProgram(query));
            }
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
        isMovie ? Expanded(
          child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
            builder: (context, state) {
              return buildSearchContent(state, isMovie);
            },
          ),
        ) :
        Expanded(
          child: BlocBuilder<TvSearchBloc, TvSearchState>(
            builder: (context, state) {
              return buildSearchContent(state, isMovie);
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildSearchContent(dynamic state, bool isMovie) {
  if (state is MovieSearchLoading || state is TvSearchLoading) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is MovieSearchHasData || state is TvSearchHasData) {
    final searchResult = isMovie
        ? (state as MovieSearchHasData).searchResult
        : (state as TvSearchHasData).searchResult;
    return ListView.builder(
        itemBuilder: (context, index) => isMovie
            ? MovieCard(movie: searchResult[index] as Movie)
            : TvCard(tv: searchResult[index] as Tv),
        itemCount: searchResult.length);
  } else if (state is MovieSearchError || state is TvSearchError) {
    return Center(
      key: const Key("error_message"),
      child: CircularProgressIndicator(),
    );
  } else {
    return Center(
      key: const Key("empty_message"),
      child: Text("Nothing Found"),
    );
  }
}
