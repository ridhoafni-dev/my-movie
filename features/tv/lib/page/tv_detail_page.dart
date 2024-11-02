import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:model/genre/genre.dart';
import 'package:model/tv/tv.dart';
import 'package:model/tv/tv_detail.dart';
import 'package:provider/provider.dart';
import 'package:styles/colors.dart';
import 'package:styles/text_styles.dart';
import 'package:tv/bloc/detail/tv_detail_bloc.dart';
import 'package:tv/bloc/detail/tv_detail_state.dart';
import 'package:tv/bloc/detail/watchlist/tv_detail_watchlist_bloc.dart';
import 'package:utils/utils.dart';

import '../bloc/detail/tv_detail_event.dart';
import '../bloc/detail/watchlist/tv_detail_watchlist_event.dart';
import '../bloc/detail/watchlist/tv_detail_watchlist_state.dart';

class TvDetailPage extends StatefulWidget {
  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
          BlocProvider.of<TvDetailBloc>(context)
              .add(FetchTvDetail(widget.id));
          BlocProvider.of<TvDetailWatchlistBloc>(context)
              .add(CheckWatchlistStatus(widget.id));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(builder: (context, state) {
        if (state is TvDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvDetailHasData) {
          final tv = state.tv;
          final recommendations = state.recommendations;
          return SafeArea(
              child: DetailContent(
                  tv, recommendations));
        } else if(state is TvDetailError) {
          return Text(state.message);
        }
        else {
          return const Center(
            child: Text("Empty"),
          );
        }
      }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;

  const DetailContent(this.tv, this.recommendations,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
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
                              tv.name,
                              style: kHeading5,
                            ),
                            BlocListener<TvDetailWatchlistBloc,
                                TvDetailWatchlistState>(
                              listenWhen: (previous, current) =>
                              (previous is UpdatingWatchlist),
                              listener: (context, state) {
                                String message = "";
                                if (state is AlreadyOnWatchlist) {
                                  message = TvDetailWatchlistBloc
                                      .watchlistAddSuccessMessage;
                                } else if (state is NotOnWatchlist) {
                                  message = TvDetailWatchlistBloc
                                      .watchlistRemoveSuccessMessage;
                                } else {
                                  message = TvDetailWatchlistBloc
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
                              child: BlocBuilder<TvDetailWatchlistBloc,
                                  TvDetailWatchlistState>(
                                  builder: (context, state) {
                                    return FilledButton(
                                        onPressed: () async {
                                          final bloc = BlocProvider.of<
                                              TvDetailWatchlistBloc>(context);
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
                            Text(_showGenres(tv.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextHeading6('Overview'),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            _buildTextHeading6('Recommendations'),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final tv = recommendations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          TV_DETAIL_ROUTE,
                                          arguments: {"id": tv.id},
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
      TvDetailWatchlistBloc bloc, TvDetailWatchlistState state) async {
    if (state is NotOnWatchlist) {
      bloc.add(AddToWatchlist(tv));
    } else {
      bloc.add(RemoveWatchlist(tv));
    }
  }

  static const successMessages = {
    TvDetailWatchlistBloc.watchlistAddSuccessMessage,
    TvDetailWatchlistBloc.watchlistRemoveSuccessMessage,
  };
}

Text _buildTextHeading6(String title) {
  return Text(
    title,
    style: kHeading6,
  );
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
