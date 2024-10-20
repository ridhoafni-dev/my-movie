import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_movie/presentation/pages/tv/now_paying_tv_page.dart';
import 'package:my_movie/presentation/pages/tv/popular_tv_page.dart';
import 'package:my_movie/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:my_movie/presentation/pages/tv/tv_detail_page.dart';
import 'package:my_movie/presentation/providers/tv/tv_series_list_notifier.dart';
import 'package:provider/provider.dart';

import '../../../common/constans.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entity/tv/tv.dart';
import '../search_page.dart';

class TvSeriesListPage extends StatefulWidget {
  static const ROUTE_NAME = "tv-series-list-page";

  const TvSeriesListPage({super.key});

  @override
  State<StatefulWidget> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<TvSeriesListNotifier>(context, listen: false)
          ..fetchNowPlayingTvSeries()
          ..fetchPopularTvSeries()
          ..fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tv Series"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSubHeading(
                title: '${TvType.NowPlaying.description} Tv Series',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayingTvPage.ROUTE_NAME),
              ),
              _buildTvList(TvType.NowPlaying),
              _buildSubHeading(
                title: '${TvType.Popular.description} Tv Series',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
              ),
              _buildTvList(TvType.Popular),
              _buildSubHeading(
                title: '${TvType.TopRated.description} Tv Series',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
              ),
              _buildTvList(TvType.TopRated),
            ]),
          )),
    );
  }
}

Widget _buildTvList(TvType type) {
  return Consumer<TvSeriesListNotifier>(builder: (context, tvData, child) {
    RequestState state;
    List<Tv> Tvs = [];
    switch (type) {
      case TvType.NowPlaying: // tv is now playing
        state = tvData.nowPlayingState;
        Tvs = tvData.nowPlayingTvSeries;
        break;
      case TvType.Popular: // tv is popular
        state = tvData.popularState;
        Tvs = tvData.popularTvSeries;
        break;
      case TvType.TopRated: //tv is top-rated
        state = tvData.topRatedState;
        Tvs = tvData.topRatedTvSeries;
        break;
      default:
        state = RequestState.Empty;
        Tvs = List.empty();
        break;
    }

    if (state == RequestState.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state == RequestState.Loaded) {
      return TvList(Tvs);
    } else {
      return Center(
        key: const Key('error_message'),
        child: Text(tvData.message),
      );
    }
  });
}

Widget _buildSubHeading({required String title, Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        if (onTap != null)
          InkWell(
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Text('See More'),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

class TvList extends StatelessWidget {
  final List<Tv> tvSeries;

  const TvList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tvSeries.length,
          itemBuilder: (context, index) {
            final tv = tvSeries[index];

            return Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TvDetailPage.ROUTE_NAME,
                        arguments: {'id': tv.id},
                      );
                    },
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ))));
          },
        ));
  }
}

enum TvType {
  Popular('Popular'),
  NowPlaying('Now Playing'),
  TopRated('Top Rated');

  final String description;

  const TvType(this.description);
}
