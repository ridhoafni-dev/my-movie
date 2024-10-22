import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:domain/repositories/tv_repository.dart';
import 'package:entity/tv_table.dart';
import 'package:model/tv/tv.dart';
import 'package:model/tv/tv_detail.dart';
import 'package:utils/utils/exception.dart';
import 'package:utils/utils/failure.dart';

import '../datasources/tv/tv_local_data_source.dart';
import '../datasources/tv/tv_remote_data_source.dart';

class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource tvRemoteDataSource;
  final TvLocalDataSource tvLocalDataSource;

  const TvRepositoryImpl(
      {required this.tvRemoteDataSource,
        required this.tvLocalDataSource});

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final result = await tvRemoteDataSource.getTvDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async {
    try {
      final result = await tvRemoteDataSource.getTvRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getNowPlayingTvSeries() async {
    try {
      final result = await tvRemoteDataSource.getNowPlayingTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvSeries() async {
    try {
      final result = await tvRemoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries() async {
    try {
      final result = await tvRemoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries() async {
    try {
      final result = await tvLocalDataSource.getWatchlistTvSeries();
      return Right(result.map((data) => data.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final result = await tvLocalDataSource
          .removeTvWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final result = await tvLocalDataSource
          .insertTvWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvSeries(String query) async {
    try {
      final result = await tvRemoteDataSource.searchTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await tvLocalDataSource.getTvById(id);
    return result != null;
  }

}
