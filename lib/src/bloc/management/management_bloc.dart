import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../../models/product.dart';
import '../../services/common.dart';
import '../../services/network_service.dart';
import '../../widgets/custom_flushbar.dart';

part 'management_event.dart';
part 'management_state.dart';

class ManagementBloc extends Bloc<ManagementEvent, ManagementState> {
  ManagementBloc() : super(ManagementState()) {
    on<ManagementEventSubmit>((event, emit) async {
      // Debug
      // emit(state.copyWith(status: SubmitStatus.submitting));
      // await Future.delayed(Duration(seconds: 2));
      // emit(state.copyWith(status: SubmitStatus.success));

      final _product = event.product!;
      final _imageFile = event.image;
      final _editMode = event.isEditMode!;
      final _form = event.form!;

      emit(state.copyWith(status: SubmitStatus.submitting));
      hideKeyboard();
      _form.currentState?.save();
      print("${_product.name},${_product.price},${_product.stock}");
      // return;
      try {
        String result;
        if (_editMode) {
          result = await NetworkService()
              .editProduct(_product, imageFile: _imageFile);
        } else {
          logger.i("Add Product : $_product");
          result = await NetworkService()
              .addProduct(_product, imageFile: _imageFile);
        }
        Navigator.pop(navigatorState.currentContext!);
        emit(state.copyWith(status: SubmitStatus.success));

        CustomFlushbar.showSuccess(navigatorState.currentContext!,
            message: result);
      } catch (exception) {
        CustomFlushbar.showError(navigatorState.currentContext!,
            message: 'network fail');
        emit(state.copyWith(status: SubmitStatus.failed));
      }
    });

    on<ManagementEventDelete>((event, emit) {
      NetworkService().deleteProduct(event.productId).then((value) {
        Navigator.pop(navigatorState.currentContext!);
        CustomFlushbar.showSuccess(navigatorState.currentContext!,
            message: value);
      }).catchError((exception) {
        CustomFlushbar.showError(navigatorState.currentContext!,
            message: 'Delete fail');
      });
    });
  }
}
