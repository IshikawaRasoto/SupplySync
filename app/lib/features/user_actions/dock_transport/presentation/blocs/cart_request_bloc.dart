import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../cart/domain/entities/cart.dart';
import '../../../../cart/domain/usecases/get_cart_details.dart';

part 'cart_request_event.dart';
part 'cart_request_state.dart';

class CartRequestBloc extends Bloc<CartRequestEvent, CartRequestState> {
  final UserCubit _userCubit;
  final GetCartDetails _requestCartDetails;
  XFile? cartPhoto;

  CartRequestBloc({
    required UserCubit userCubit,
    required GetCartDetails requestCartDetails,
  })  : _userCubit = userCubit,
        _requestCartDetails = requestCartDetails,
        super(CartRequestInitial()) {
    on<RequestCartInformationRequested>(_onRequestCartInformation);
    on<CartPhotoSubmitted>(_onCartPhotoSubmitted);
  }

  bool get hasPhoto => cartPhoto != null;

  void _onRequestCartInformation(
    RequestCartInformationRequested event,
    Emitter<CartRequestState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(CartRequestFailure('Usuário não autenticado'));
      return;
    }
    emit(CartRequestInProgress());
    final result = await _requestCartDetails(GetCartDetailsParams(
      jwtToken: currentUser.jwtToken,
      id: event.cartId,
    ));
    result.fold(
      (failure) => emit(CartRequestFailure(failure.message)),
      (cart) => emit(CartRequestCartDetailsSuccess(cart)),
    );
  }

  void _onCartPhotoSubmitted(
    CartPhotoSubmitted event,
    Emitter<CartRequestState> emit,
  ) {
    // TODO: Implementar a chamada para enviar a foto via API
    cartPhoto = event.photo;
    emit(CartRequestSuccess());
  }
}
