sealed class Result<S, F> {}

class Success<S, F> extends Result<S, F> {
  final S value;
  Success(this.value);
}

class FailureResult<S, F> extends Result<S, F> {
  final F failure;
  FailureResult(this.failure);
}
