import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lg_star_command/features/dashboard/data/dashboard_repository.dart';
import 'package:lg_star_command/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:lg_star_command/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<StartOrbit>(_onStartOrbit);
    on<StopOrbit>(_onStopOrbit);
    on<CleanRig>(_onCleanRig);
  }

  Future<void> _onStartOrbit(StartOrbit event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      await _repository.sendTajMahalTour();
      await _repository.startTour();
      emit(DashboardTouring());
    } catch (e) {
      emit(DashboardError('Failed to start orbit: $e'));
    }
  }

  Future<void> _onStopOrbit(StopOrbit event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      await _repository.stopTour();
      emit(const DashboardSuccess('Orbit stopped'));
    } catch (e) {
      emit(DashboardError('Failed to stop orbit: $e'));
    }
  }

  Future<void> _onCleanRig(CleanRig event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      await _repository.cleanRig();
      emit(const DashboardSuccess('Rig cleaned'));
    } catch (e) {
      emit(DashboardError('Failed to clean rig: $e'));
    }
  }
}