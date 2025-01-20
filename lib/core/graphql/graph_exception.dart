class GraphQLException implements Exception {
  final String message;
  final GraphQLErrorType type;

  const GraphQLException({
    required this.message,
    this.type = GraphQLErrorType.unknown,
  });

  @override
  String toString() => message;
}

enum GraphQLErrorType {
  network('Network error occurred'),
  auth('Authentication failed'),
  notFound('Resource not found'),
  server('Server error occurred'),
  validation('Validation error'),
  subscription('Subscription error'),
  unknown('An unknown error occurred');

  final String defaultMessage;
  const GraphQLErrorType(this.defaultMessage);

  static GraphQLErrorType fromCode(String code) {
    return switch (code) {
      'UNAUTHENTICATED' => GraphQLErrorType.auth,
      'NOT_FOUND' => GraphQLErrorType.notFound,
      'BAD_REQUEST' => GraphQLErrorType.validation,
      'INTERNAL_SERVER_ERROR' => GraphQLErrorType.server,
      'SUBSCRIPTION_FAILED' => GraphQLErrorType.subscription,
      _ => GraphQLErrorType.unknown,
    };
  }
}
