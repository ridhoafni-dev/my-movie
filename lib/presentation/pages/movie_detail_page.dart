import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:model/genre/genre.dart';
import 'package:model/movie/movie.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:my_movie/presentation/providers/movie/movie_detail_notifier.dart';
import 'package:provider/provider.dart';
import 'package:styles/styles.dart';
import 'package:utils/core.dart';

class MovieDetailPage extends StatefulWidget {

  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieDetailNotifier>(context, listen: false)
          ..fetchMovieDetail(widget.id)
          ..loadWatchlistStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(builder: (context, provider, child) {
        if (provider.movieDetailState == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.movieDetailState == RequestState.Loaded) {
          final movie = provider.movieDetail;
          return SafeArea(
              child: DetailContent(movie, provider.movieRecommendations,
                  provider.isAddedToWatchlist));
        } else {
          return Text(provider.message);
        }
      }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.movie, this.recommendations, this.isAddedWatchlist,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            FilledButton(
                                onPressed: () async {
                                  final notifier =
                                      Provider.of<MovieDetailNotifier>(context,
                                          listen: false);

                                  await _updateWatchlist(notifier);

                                  final feedbackMessage =
                                      notifier.watchlistMessage;

                                  if (successMessages
                                      .contains(feedbackMessage)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(feedbackMessage)));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(feedbackMessage),
                                          );
                                        });
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text('Watchlist')
                                  ],
                                )),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextHeading6('Overview'),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            _buildTextHeading6('Recommendations'),
                            Consumer<MovieDetailNotifier>(
                                builder: (context, data, child) {
                              if (data.movieRecommendationsState ==
                                  RequestState.Loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (data.movieRecommendationsState ==
                                  RequestState.Error) {
                                return Text(data.message);
                              } else if (data.movieRecommendationsState ==
                                  RequestState.Loaded) {
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final movie = recommendations[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                MOVIE_DETAIL_ROUTE,
                                                arguments: movie.id);
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '$BASE_IMAGE_URL${movie.posterPath}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: recommendations.length,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
        )
      ],
    );
  }

  Future<void> _updateWatchlist(MovieDetailNotifier notifier) async {
    if (!isAddedWatchlist) {
      await notifier.addWatchlist(movie);
    } else {
      await notifier.removeFromWatchlist(movie);
    }
  }

  static const successMessages = {
    MovieDetailNotifier.watchlistAddSuccessMessage,
    MovieDetailNotifier.watchlistRemoveSuccessMessage,
  };
}

Text _buildTextHeading6(String title) {
  return Text(
    title,
    style: kHeading6,
  );
}

String _showDuration(int runtime) {
  final int hours = runtime ~/ 60;
  final minutes = runtime % 60;

  if (hours > 0) {
    return '$hours h $minutes m';
  } else {
    return '$minutes m';
  }
}

String _showGenres(List<Genre> genres) {
  String result = '';
  for (var genre in genres) {
    result += '${genre.name}, ';
  }
  if (result.isEmpty) {
    return result;
  }
  return result.substring(0, result.length - 2);
}
