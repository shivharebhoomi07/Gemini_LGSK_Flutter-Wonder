import 'package:equatable/equatable.dart';

class ConnectionParams extends Equatable {
  final String ip;
  final int port;
  final String username;
  final String password;
  final int screenCount;

  const ConnectionParams({
    required this.ip,
    required this.port,
    required this.username,
    required this.password,
    required this.screenCount,
  });

  @override
  List<Object> get props => [ip, port, username, password, screenCount];
}