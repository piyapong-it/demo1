import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState()) {
    // Add
    on<CounterEventAdd>((event, emit) {
      emit(state.copyWith(count1: state.count1 + 1, count2: state.count2 + 1));
    });

    // Remove
    on<CounterEventRemove>((event, emit) {
      emit(state.copyWith(count1: state.count1 - 1, count2: state.count2 - 1));
    });
 // Set
    on<CounterEventSet1>((event, emit) {
      emit(state.copyWith(count1: event.newValue));
    });
  }
}
