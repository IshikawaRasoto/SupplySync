import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplysync/features/cart/domain/usecases/report_cart_problem.dart';

import '../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../../cart/domain/entities/cart.dart';
import '../../../../cart/domain/usecases/get_cart_details.dart';
import '../../../../cart/domain/usecases/release_drone.dart';
import '../../domain/usecases/upload_cart_photo.dart';

part 'cart_request_event.dart';
part 'cart_request_state.dart';

class CartRequestBloc extends Bloc<CartRequestEvent, CartRequestState> {
  final UserCubit _userCubit;
  final GetCartDetails _requestCartDetails;
  final UploadCartPhoto _uploadCartPhoto;
  final ReleaseDrone _releaseDrone;
  final ReportCartProblem _reportCartProblem;
  XFile? cartPhoto;
  String? currentCartId;

  CartRequestBloc({
    required UserCubit userCubit,
    required GetCartDetails requestCartDetails,
    required UploadCartPhoto uploadCartPhoto,
    required ReleaseDrone releaseDrone,
    required ReportCartProblem reportCartProblem,
  })  : _userCubit = userCubit,
        _requestCartDetails = requestCartDetails,
        _uploadCartPhoto = uploadCartPhoto,
        _releaseDrone = releaseDrone,
        _reportCartProblem = reportCartProblem,
        super(CartRequestInitial()) {
    on<RequestCartInformationRequested>(_onRequestCartInformation);
    on<CartPhotoSubmitted>(_onCartPhotoSubmitted);
    on<ReleaseCartRequested>(_onReleaseCartRequested);
    on<ResetCartRequestEvent>(_onResetCartRequest);
    on<CartReportProblemEvent>(_onReportProblem);
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
      (cart) {
        currentCartId = cart.id;
        emit(CartRequestCartDetailsSuccess(cart));
      },
    );
  }

  void _onCartPhotoSubmitted(
    CartPhotoSubmitted event,
    Emitter<CartRequestState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(CartRequestFailure('Usuário não autenticado'));
      return;
    }
    if (currentCartId == null) {
      emit(CartRequestFailure('ID do carrinho não disponível'));
      return;
    }
    emit(CartRequestInProgress());
    final result = await _uploadCartPhoto(UploadCartPhotoParams(
      jwtToken: currentUser.jwtToken,
      cartId: currentCartId!,
      photo: event.photo,
    ));
    result.fold(
      (failure) => emit(CartRequestFailure(failure.message)),
      (_) {
        cartPhoto = event.photo;
        emit(CartRequestSuccess());
      },
    );
  }

  void _onReleaseCartRequested(
    ReleaseCartRequested event,
    Emitter<CartRequestState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(CartRequestFailure('Usuário não autenticado'));
      return;
    }
    if (currentCartId == null) {
      emit(CartRequestFailure('ID do carrinho não disponível'));
      return;
    }
    if (!hasPhoto) {
      emit(CartRequestFailure(
          'É necessário tirar uma foto antes de liberar o carrinho'));
      return;
    }
    emit(CartRequestInProgress());
    final result = await _releaseDrone(ReleaseDroneParams(
      jwtToken: currentUser.jwtToken,
      droneId: currentCartId!,
    ));
    result.fold(
      (failure) => emit(CartRequestFailure(failure.message)),
      (_) => emit(CartReleased()),
    );
  }

  void _onResetCartRequest(
    ResetCartRequestEvent event,
    Emitter<CartRequestState> emit,
  ) {
    cartPhoto = null;
    currentCartId = null;
    emit(CartRequestInitial());
  }

  void _onReportProblem(
    CartReportProblemEvent event,
    Emitter<CartRequestState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(CartRequestFailure('Usuário não autenticado'));
      return;
    }
    if (currentCartId == null) {
      emit(CartRequestFailure('ID do carrinho não disponível'));
      return;
    }
    emit(CartRequestInProgress());
    final result = await _reportCartProblem(ReportCartProblemParams(
      jwtToken: currentUser.jwtToken,
      cartId: currentCartId!,
      problemDescription: event.problemDescription,
    ));
    result.fold(
      (failure) => emit(CartRequestFailure(failure.message)),
      (_) {
        emit(CartSendProblemSuccess());
        emit(CartRequestSuccess());
      },
    );
  }
}
