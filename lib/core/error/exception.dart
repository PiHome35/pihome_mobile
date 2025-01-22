class ServerException implements Exception {
  final String? message;
  ServerException({this.message});
}

class ConnectionTimeoutException implements Exception {}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NotDataFoundException implements Exception {}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
