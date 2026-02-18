import 'package:equatable/equatable.dart';
import 'package:lg_star_command/core/models/connection_params.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object> get props => [];
}

class ConnectToLG extends ConnectionEvent {
  final ConnectionParams params;

  const ConnectToLG(this.params);

  @override
  List<Object> get props => [params];
}

class DisconnectFromLG extends ConnectionEvent {}

class CheckConnectionStatus extends ConnectionEvent {}
