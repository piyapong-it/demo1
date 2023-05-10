import 'package:bloc/bloc.dart';
import 'package:demo1/src/services/network_service.dart';
import 'package:equatable/equatable.dart';

import '../../models/product.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    // Fetch
    on<HomeEventFetch>((event, emit) async {
      emit(state.copywith(status: FetchStatus.success, products: []));
      emit(state.copywith(status: FetchStatus.fetching));
      await Future.delayed(Duration(milliseconds: 300));
      final products = await NetworkService().getProduct();
      emit(state.copywith(status: FetchStatus.success, products: products));
    });

        // Toggle display mode
    on<HomeEventToggleDisplay>((event, emit) {
      emit(state.copywith(isGrid: !state.isGrid));
    });
  }
}