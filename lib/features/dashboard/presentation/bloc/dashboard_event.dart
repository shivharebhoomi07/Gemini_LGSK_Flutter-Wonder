import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class StartOrbit extends DashboardEvent {}

class StopOrbit extends DashboardEvent {}

class CleanRig extends DashboardEvent {}