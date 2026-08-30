sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

final class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

final class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure(super.message);
}

final class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure(super.message);
}

final class AccountDisabledFailure extends Failure {
  const AccountDisabledFailure(super.message);
}

final class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure(super.message);
}