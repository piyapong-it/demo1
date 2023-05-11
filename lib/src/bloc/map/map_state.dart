part of 'map_bloc.dart';

class MapState extends Equatable {
  final LatLng currentPosition;
  MapState({required this.currentPosition});

  MapState copyWith({LatLng? currentPosition}) {
    return MapState(currentPosition: currentPosition ?? this.currentPosition);
  }

  @override
  List<Object> get props => [currentPosition];
}