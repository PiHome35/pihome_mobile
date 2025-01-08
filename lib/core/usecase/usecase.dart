abstract class UseCase<T, Params> {
  Future<T> execute(Params params);
}
