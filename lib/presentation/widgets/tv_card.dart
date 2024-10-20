import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../common/constans.dart';
import '../../domain/entity/tv/tv.dart';
import '../pages/tv/tv_detail_page.dart';

class TvCard extends StatelessWidget {
  final Tv tv;

  const TvCard({super.key, required this.tv});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, TvDetailPage.ROUTE_NAME,
              arguments: {'id': tv.id});
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 16 + 80 + 16, bottom: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tv.name ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        tv.overview ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )),
            ),
            Container(
                margin: const EdgeInsets.only(left: 16, bottom: 16),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                    width: 80,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
