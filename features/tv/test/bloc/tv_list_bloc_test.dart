import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:domain/usecases/tv/get_popular_tv_series.dart';
import 'package:domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:model/model.dart';
import 'package:tv/bloc/list/tv_list_bloc.dart';
import 'package:tv/bloc/list/tv_list_event.dart';
import 'package:tv/bloc/list/tv_list_state.dart';
import 'package:utils/utils/failure.dart';

import 'tv_list_bloc_test.mocks.dart';


@GenerateMocks([GetNowPlayingTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvListBloc movieListBloc;

  late MockGetNowPlayingTvSeries mockGetNowPlayingMovies;
  late MockGetPopularTvSeries mockGetPopularMovies;
  late MockGetTopRatedTvSeries mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingTvSeries();
    mockGetPopularMovies = MockGetPopularTvSeries();
    mockGetTopRatedMovies = MockGetTopRatedTvSeries();
    movieListBloc = TvListBloc(
      getNowPlayingTvSeries: mockGetNowPlayingMovies,
      getPopularTvSeries: mockGetPopularMovies,
      getTopRatedTvSeries: mockGetTopRatedMovies,
    );
  });

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTv];

  blocTest<TvListBloc, TvListState>(
    'Should emit [Loading,HasData] when get fetch is success',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tTvList));

      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchTvList()),
    expect: () => [
      TvListLoading(),
      TvListHasData(
        nowPlaying: tTvList,
        popular: tTvList,
        topRated: tTvList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetTopRatedMovies.execute());
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [Loading,Error] when get fetch is failed',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('fail')));

      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchTvList()),
    expect: () => [TvListLoading(), const TvListError('fail')],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetTopRatedMovies.execute());
      verify(mockGetPopularMovies.execute());
    },
  );
}
