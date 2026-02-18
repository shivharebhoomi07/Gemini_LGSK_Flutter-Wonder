import 'package:equatable/equatable.dart';
import 'package:lg_star_command/core/models/connection_params.dart';

abstract class LGConnectionState extends Equatable {
  const LGConnectionState();

  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends LGConnectionState {}

class ConnectionLoading extends LGConnectionState {}

class ConnectionSuccess extends LGConnectionState {
  final ConnectionParams params;

  const ConnectionSuccess(this.params);

  @override
  List<Object> get props => [params];
}

class ConnectionFailure extends LGConnectionState {
  final String message;

  const ConnectionFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ConnectionDisconnected extends LGConnectionState {}
