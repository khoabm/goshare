class Failure {
  final String message;

  Failure(this.message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(super.message);
}

class AlreadyInTripFailure extends Failure {
  AlreadyInTripFailure(super.message);
}
