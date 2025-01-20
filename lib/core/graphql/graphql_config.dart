import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_pihome/config/config_path.dart';

class GraphQLConfig {
  GraphQLConfig._();

  static final GraphQLConfig _instance = GraphQLConfig._();

  factory GraphQLConfig() => _instance;

  static const String _graphQLEndpoint = '$hostUrl/graphql';
  static final HttpLink _httpLink = HttpLink(_graphQLEndpoint);
  static final GraphQLCache _cache = GraphQLCache();
  static const String _websocketEndpoint = wsHostUrl;

  

  static Link _splitLink(String? token) {
    // Update WebSocketLink with the token when needed
    final wsLink = WebSocketLink(
      _websocketEndpoint,
      config: SocketClientConfig(
        initialPayload: () => {
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
      ),
    );

    final authLink = AuthLink(
      getToken: () => token != null ? 'Bearer $token' : '',
    );

    return Link.split(
      (request) => request.isSubscription,
      token != null ? authLink.concat(wsLink) : wsLink,
      token != null ? authLink.concat(_httpLink) : _httpLink,
    );
  }

  static GraphQLClient getClient({String? token}) {
    return GraphQLClient(
      link: _splitLink(token),
      cache: _cache,
    );
  }

  GraphQLClient get client => getClient();

  GraphQLClient clientWithToken(String token) => getClient(token: token);
}
