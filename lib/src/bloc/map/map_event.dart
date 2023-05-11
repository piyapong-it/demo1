part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object?> get props => [];
}

class MapEventSubmitLocation extends MapEvent {
  final LatLng? position;
  const MapEventSubmitLocation({this.position});
}