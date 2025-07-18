sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;

  const factory Result.error(Object error) = Error._;

}

final class Ok<T> extends Result<T> {
  final T value;

  const Ok._(this.value);

  @override
  String toString() => 'Ok(value: $value)';
}

final class Error<T> extends Result<T> {
  final Object error;

  const Error._(this.error);

  @override
  String toString() => 'Error(error: $error)';
}