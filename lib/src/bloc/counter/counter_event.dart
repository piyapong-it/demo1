part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

// Add
class CounterEventAdd extends CounterEvent {}

// Remove
class CounterEventRemove extends CounterEvent {}

//set
class CounterEventSet1 extends CounterEvent {
  final int newValue;
  CounterEventSet1(this.newValue);
}
