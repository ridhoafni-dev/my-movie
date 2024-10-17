class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException({required this.message});
}
