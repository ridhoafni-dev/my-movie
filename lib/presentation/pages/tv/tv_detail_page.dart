import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_movie/common/constans.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/genre.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/domain/entity/tv/tv_detail.dart';
import 'package:my_movie/presentation/providers/tv/tv_detail_notifier.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TvDetailNotifier>(context, listen: false)
      ..fetchTvDetail(widget.id)
      ..loadWatchlistStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(builder: (context, provider, child) {
        if (provider.tvDetailState == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.tvDetailState == RequestState.Loaded) {
          final tv = provider.tvDetail;
          return SafeArea(
              child: DetailContent(
                  tv, provider.tvRecommendations, provider.isAddedToWatchlist));
        } else {
          return Text(provider.message);
        }
      }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.tv, this.recommendations, this.isAddedWatchlist,
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
                            FilledButton(
                                onPressed: () async {
                                  final notifier =
                                      Provider.of<TvDetailNotifier>(context,
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
                            Consumer<TvDetailNotifier>(
                                builder: (context, data, child) {
                              if (data.tvRecommendationsState ==
                                  RequestState.Loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (data.tvRecommendationsState ==
                                  RequestState.Error) {
                                return Text(data.message);
                              } else if (data.tvRecommendationsState ==
                                  RequestState.Loaded) {
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tv = data.tvRecommendations[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: {"id": tv.id});
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '$BASE_IMAGE_URL${tv.posterPath}',
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
                                    itemCount: data.tvRecommendations.length,
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

  Future<void> _updateWatchlist(TvDetailNotifier notifier) async {
    if (!isAddedWatchlist) {
      await notifier.addWatchlist(tv);
    } else {
      await notifier.removeFromWatchlist(tv);
    }
  }

  static const successMessages = {
    TvDetailNotifier.watchlistAddSuccessMessage,
    TvDetailNotifier.watchlistRemoveSuccessMessage,
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
