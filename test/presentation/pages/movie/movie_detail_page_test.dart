import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/presentation/pages/movie/movie_detail_page.dart';
import 'package:my_movie/presentation/providers/movie/movie_detail_notifier.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_object.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(value: mockNotifier, child: MaterialApp(
      home: body,
    ));
  }

  testWidgets("watchlist button should display add icon when movie not added to watchlist", (WidgetTester tester) async {
    when(mockNotifier.movieDetailState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieDetail).thenReturn(testMovieDetail);
    when(mockNotifier.movieRecommendationsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
          (WidgetTester tester) async {
        when(mockNotifier.movieDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieDetail).thenReturn(testMovieDetail);
        when(mockNotifier.movieRecommendationsState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.movieDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieDetail).thenReturn(testMovieDetail);
        when(mockNotifier.movieRecommendationsState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

        final watchlistButton = find.byType(FilledButton);

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });


  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.movieDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieDetail).thenReturn(testMovieDetail);
        when(mockNotifier.movieRecommendationsState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Failed');

        final watchlistButton = find.byType(FilledButton);

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}