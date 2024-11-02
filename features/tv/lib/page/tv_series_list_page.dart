import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model/tv/tv.dart';
import 'package:styles/text_styles.dart';
import 'package:tv/bloc/list/tv_list_bloc.dart';
import 'package:tv/bloc/list/tv_list_event.dart';
import 'package:tv/bloc/list/tv_list_state.dart';
import 'package:utils/utils.dart';

class TvSeriesListPage extends StatefulWidget {
  const TvSeriesListPage({super.key});

  @override
  State<StatefulWidget> createState() => _TvSeriesListPageState();
}

class _TvSeriesListPageState extends State<TvSeriesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TvListBloc>(context, listen: false).add(FetchTvList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tv Series"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE);
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
                    Navigator.pushNamed(context, NOW_PLAYING_TV_SERIES_ROUTE),
              ),
              _buildTvList(TvType.NowPlaying),
              _buildSubHeading(
                title: '${TvType.Popular.description} Tv Series',
                onTap: () =>
                    Navigator.pushNamed(context, POPULAR_TV_SERIES_ROUTE),
              ),
              _buildTvList(TvType.Popular),
              _buildSubHeading(
                title: '${TvType.TopRated.description} Tv Series',
                onTap: () =>
                    Navigator.pushNamed(context, TOP_RATED_MOVIES_ROUTE),
              ),
              _buildTvList(TvType.TopRated),
            ]),
          )),
    );
  }
}

Widget _buildTvList(TvType type) {
  return BlocBuilder<TvListBloc, TvListState>(builder: (context, state) {
    if (state is TvListLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is TvListHasData) {
      final tvSeries = type == TvType.NowPlaying
          ? state.nowPlaying
          : type == TvType.Popular
              ? state.popular
              : state.topRated;

      return TvList(tvSeries);
    } else if (state is TvListError) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    } else {
      return const Center(
        key: const Key('empty_message'),
        child: Text('Empty'),
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
                        TV_DETAIL_ROUTE,
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
