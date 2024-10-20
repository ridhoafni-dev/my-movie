import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/tv/tv.dart';
import 'package:my_movie/presentation/pages/tv/tv_detail_page.dart';
import 'package:my_movie/presentation/providers/tv/tv_detail_notifier.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_object.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(value: mockNotifier, child: MaterialApp(
      home: body,
    ));
  }

  testWidgets("watchlist button should display add icon when Tv not added to watchlist", (WidgetTester tester) async {
    when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvDetail).thenReturn(testTvDetail);
    when(mockNotifier.tvRecommendationsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv is added to wathclist',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationsState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationsState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

        final watchlistButton = find.byType(FilledButton);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });


  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationsState).thenReturn(RequestState.NotFound); //(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Failed');

        final watchlistButton = find.byType(FilledButton);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}