sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class ServerException extends AppException {
  const ServerException(super.message);
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

final class AuthenticationException extends AppException {
  const AuthenticationException(super.message);
}

final class UnknownException extends AppException {
  const UnknownException(super.message);
}
