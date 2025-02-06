part of 'dock_transport_bloc.dart';

@immutable
sealed class DockTransportState {}

class DockTransportInitial extends DockTransportState {}

class DockTransportLoading extends DockTransportState {}

class DockTransportSuccess extends DockTransportState {}

class DockTransportFailure extends DockTransportState {
  final String error;
  DockTransportFailure(this.error);
}
