part of 'management_bloc.dart';

abstract class ManagementEvent extends Equatable {
  const ManagementEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ManagementEventSubmit extends ManagementEvent {
  final Product? product;
  final File? image;
  final bool? isEditMode;
  final GlobalKey<FormState>? form;

  const ManagementEventSubmit({
    this.product,
    this.image,
    this.isEditMode,
    this.form,
  });
}

class ManagementEventDelete extends ManagementEvent {
  final int productId;
  const ManagementEventDelete(this.productId);
}
