import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:model/genre/genre.dart';
import 'package:model/movie/movie.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:movie/bloc/detail/movie_detail_bloc.dart';
import 'package:movie/bloc/detail/movie_detail_state.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_bloc.dart';
import 'package:movie/bloc/detail/watchlist/movie_detail_watchlist_state.dart';
import 'package:styles/colors.dart';
import 'package:styles/text_styles.dart';
import 'package:utils/utils.dart';

import '../bloc/detail/movie_detail_event.dart';
import '../bloc/detail/watchlist/movie_detail_watchlist_event.dart';

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
    Future.microtask(() {
      BlocProvider.of<MovieDetailBloc>(context)
          .add(FetchMovieDetail(widget.id));
      BlocProvider.of<MovieDetailWatchlistBloc>(context)
          .add(CheckWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
        if (state is MovieDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieDetailHasData) {
          final movie = state.movie;
          final recommendations = state.recommendations;

          return SafeArea(child: DetailContent(movie, recommendations));
        } else if (state is MovieDetailError) {
          return Text(state.message);
        } else {
          return const Text('Empty Data');
        }
      }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;

  const DetailContent(this.movie, this.recommendations, {super.key});

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
                            BlocListener<MovieDetailWatchlistBloc,
                                MovieDetailWatchlistState>(
                              listenWhen: (previous, current) =>
                                  (previous is UpdatingWatchlist),
                              listener: (context, state) {
                                String message = "";
                                if (state is AlreadyOnWatchlist) {
                                  message = MovieDetailWatchlistBloc
                                      .watchlistAddSuccessMessage;
                                } else if (state is NotOnWatchlist) {
                                  message = MovieDetailWatchlistBloc
                                      .watchlistRemoveSuccessMessage;
                                } else {
                                  message = MovieDetailWatchlistBloc
                                      .watchlistErrorMessage;
                                }

                                if (successMessages.contains(message)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: BlocBuilder<MovieDetailWatchlistBloc,
                                      MovieDetailWatchlistState>(
                                  builder: (context, state) {
                                return FilledButton(
                                    onPressed: () async {
                                      final bloc = BlocProvider.of<
                                          MovieDetailWatchlistBloc>(context);
                                      _updateWatchlist(bloc, state);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        state is AlreadyOnWatchlist
                                            ? const Icon(Icons.check)
                                            : const Icon(Icons.add),
                                        const Text('Watchlist')
                                      ],
                                    ));
                              }),
                            ),
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
                            SizedBox(
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
                                          arguments: {"id": movie.id},
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recommendations.length,
                              ),
                            ),
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

  Future<void> _updateWatchlist(
      MovieDetailWatchlistBloc bloc, MovieDetailWatchlistState state) async {
    if (state is NotOnWatchlist) {
      bloc.add(AddToWatchlist(movie));
    } else {
      bloc.add(RemoveWatchlist(movie));
    }
  }

  static const successMessages = {
    MovieDetailWatchlistBloc.watchlistAddSuccessMessage,
    MovieDetailWatchlistBloc.watchlistRemoveSuccessMessage,
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
