class ServerException implements Exception {}

class ConnectionTimeoutException implements Exception {}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NotDataFoundException implements Exception {}
