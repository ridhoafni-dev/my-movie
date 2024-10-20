import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils/state_enum.dart';

import '../providers/movie_search_notifier.dart';
import '../providers/tv_search_notifier.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<MovieSearchNotifier>(context, listen: false)
                    .fetchMovieSearch(query);
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
            // Text(
            //   "Search Result",
            //   style: kHeading6,
            // ),
            Consumer2<MovieSearchNotifier, TvSearchNotifier>(
                builder: (context, movieData, tvData, child) {
              if (movieData.state == RequestState.Loading &&
                  tvData.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (movieData.state == RequestState.Loaded &&
                  tvData.state == RequestState.Loaded) {
                final movies = movieData.searchResult;
                final tvShows = tvData.searchResult;
                return Expanded(
                  child: ListView(
                    children: [
                      if (movies.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Movies",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final movie = movies[index];

                            return MovieCard(movie: movie);
                          },
                          itemCount: movies.length,
                        )
                      ],
                      if (tvShows.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Tv Series",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final tvShow = tvShows[index];

                            return TvCard(tv: tvShow);
                          },
                          itemCount: tvShows.length,
                        )
                      ],
                    ],
                  ),
                );
              } else {
                return Expanded(child: Container());
              }
            })
          ],
        ),
      ),
    );
  }
}
