part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

// Fetch Product Event
class HomeEventFetch extends HomeEvent {}

class HomeEventToggleDisplay extends HomeEvent {}