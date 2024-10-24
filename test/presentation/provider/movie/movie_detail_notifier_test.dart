import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie/common/failure.dart';
import 'package:my_movie/common/state_enum.dart';
import 'package:my_movie/domain/entity/movie/movie.dart';
import 'package:my_movie/domain/usecases/movie/get_movie_detail.dart';
import 'package:my_movie/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:my_movie/domain/usecases/movie/get_movie_watchlist_status.dart';
import 'package:my_movie/domain/usecases/movie/remove_movie_watchlist.dart';
import 'package:my_movie/domain/usecases/movie/save_movie_watchlist.dart';
import 'package:my_movie/presentation/providers/movie/movie_detail_notifier.dart';

import '../../../dummy_data/dummy_object.dart';
import 'movie_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetMovieWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieDetailNotifier provider;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetMovieWatchListStatus mockGetWatchlistStatus;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetMovieWatchListStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();
    provider = MovieDetailNotifier(
      useCaseGetMovieDetail: mockGetMovieDetail,
      useCaseGetMovieRecommendations: mockGetMovieRecommendations,
      useCaseGetWatchListStatus: mockGetWatchlistStatus,
      useCaseSaveWatchlist: mockSaveWatchlist,
      useCaseRemoveWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    video: false,
  );
  final tMovies = <Movie>[tMovie];

  void arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => const Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      arrangeUsecase();
      // act
      provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieDetailState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieDetailState, RequestState.Loaded);
      expect(provider.movieDetail, testMovieDetail);
      expect(listenerCallCount, 2);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieRecommendationsState, RequestState.Loaded);
      expect(provider.movieRecommendations, tMovies);
    });
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieRecommendations.execute(tId));
      expect(provider.movieRecommendations, tMovies);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieRecommendationsState, RequestState.Loaded);
      expect(provider.movieRecommendations, tMovies);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieRecommendationsState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Success'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      verify(mockSaveWatchlist.execute(testMovieDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testMovieDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieDetailState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
