import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lg_star_command/features/connection/data/connection_repository.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_event.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, LGConnectionState> {
  final ConnectionRepository repository;

  ConnectionBloc(this.repository) : super(ConnectionInitial()) {
    on<ConnectToLG>(_onConnect);
    on<DisconnectFromLG>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckStatus);
  }

  Future<void> _onConnect(ConnectToLG event, Emitter<LGConnectionState> emit) async {
    emit(ConnectionLoading());
    try {
      await repository.connect(event.params);
      emit(ConnectionSuccess(event.params));
    } catch (e) {
      emit(ConnectionFailure(e.toString()));
    }
  }

  Future<void> _onDisconnect(DisconnectFromLG event, Emitter<LGConnectionState> emit) async {
    await repository.disconnect();
    emit(ConnectionDisconnected());
  }

  Future<void> _onCheckStatus(CheckConnectionStatus event, Emitter<LGConnectionState> emit) async {
     // Check if we have saved params and can auto-connect or at least pre-fill
     final savedParams = await repository.getSavedParams();
     if (savedParams != null) {
       // Ideally we might want to auto-connect here, or just emit a state like "ReadyToConnect" with params
       // For now, let's just stay in Initial but maybe we can use this later
     }
  }
}