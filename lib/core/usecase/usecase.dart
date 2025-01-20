abstract class UseCase<Type, Params> {
  Future<Type> execute(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> execute(Params params);
}

class NoParams {
  const NoParams();
}
