import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/network_api.dart';
import '../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<AuthEventLogin>((event, emit) async {
      emit(state.copyWith(status: LoginStatus.fetching));
      await Future.delayed(Duration(milliseconds: 1000));
      final String username = event.payload.username;
      final String password = event.payload.password;

      if (username == 'admin' && password == '1234') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(NetworkAPI.token, "12341241243134134");
        prefs.setString(NetworkAPI.username, username);
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(state.copyWith(dialogMessage: "Invalid username or password!", status: LoginStatus.failed));
      }
    });
  }
}