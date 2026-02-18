class LGException implements Exception {
  final String message;

  LGException(this.message);

  @override
  String toString() => 'LGException: $message';
}

class SSHConnectionException extends LGException {
  SSHConnectionException(super.message);
}

class SSHExecutionException extends LGException {
  SSHExecutionException(super.message);
}