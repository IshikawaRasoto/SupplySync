part of 'dock_transport_bloc.dart';

@immutable
sealed class DockTransportState {
  final String? item;
  final int? quantity;
  final String? location;
  final String? destination;

  const DockTransportState({
    this.item,
    this.quantity,
    this.location,
    this.destination,
  });

  bool get hasLocation => location != null && location!.isNotEmpty;
  bool get hasItem => item != null && item!.isNotEmpty;
  bool get hasAllInfo =>
      hasLocation &&
      hasItem &&
      quantity != null &&
      destination != null &&
      destination!.isNotEmpty;
}

class DockTransportInitial extends DockTransportState {
  const DockTransportInitial();
}

class DockTransportLoading extends DockTransportState {
  const DockTransportLoading({
    super.item,
    super.quantity,
    super.location,
    super.destination,
  });
}

class DockTransportInProgress extends DockTransportState {
  const DockTransportInProgress({
    super.item,
    super.quantity,
    super.location,
    super.destination,
  });
}

class DockTransportSuccess extends DockTransportState {
  const DockTransportSuccess(this.cartId);

  final String cartId;
}

class DockTransportFailure extends DockTransportState {
  final String error;

  const DockTransportFailure(
    this.error, {
    super.item,
    super.quantity,
    super.location,
    super.destination,
  });
}
