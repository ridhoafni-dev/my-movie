import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:domain/repositories/movie_repository.dart';
import 'package:entity/movie_table.dart';
import 'package:model/movie/movie.dart';
import 'package:model/movie/movie_detail.dart';
import 'package:utils/utils/exception.dart';
import 'package:utils/utils/failure.dart';

import '../datasources/movie/movie_local_data_source.dart';
import '../datasources/movie/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource movieRemoteDataSource;
  final MovieLocalDataSource movieLocalDataSource;

  const MovieRepositoryImpl(
      {required this.movieRemoteDataSource,
        required this.movieLocalDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final result = await movieRemoteDataSource.getNowPlayingMovies();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final result = await movieRemoteDataSource.getMovieDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async {
    try {
      final result = await movieRemoteDataSource.getMovieRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final result = await movieRemoteDataSource.getPopularMovies();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    try {
      final result = await movieRemoteDataSource.getTopRatedMovies();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async {
    try {
      final result = await movieLocalDataSource.getWatchlistMovies();
      return Right(result.map((data) => data.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async {
    try {
      final result = await movieLocalDataSource
          .removeWatchlist(MovieTable.fromEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async {
    try {
      final result = await movieLocalDataSource
          .insertWatchlist(MovieTable.fromEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final result = await movieRemoteDataSource.searchMovies(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await movieLocalDataSource.getMovieById(id);
    return result != null;
  }

}
