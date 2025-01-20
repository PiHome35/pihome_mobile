import 'package:mobile_pihome/core/graphql/graph_exception.dart';

abstract class GraphqlDataState<T> {
  final T? data;
  final GraphQLException? error;

  const GraphqlDataState({this.data, this.error});
}

class GraphqlDataSuccess<T> extends GraphqlDataState<T> {
  const GraphqlDataSuccess(T? data) : super(data: data);
}

class GraphqlDataFailed<T> extends GraphqlDataState<T> {
  const GraphqlDataFailed(GraphQLException error) : super(error: error);
}
