// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, unnecessary_string_escapes

import 'package:buy_this_app/Repository/repository.dart';
import 'package:buy_this_app/SubscribeBloc/subscribe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit() : super(SubscribeState.empty());

  Repository _repository = Repository();

  void changeEmail(String email) {
    emit(state.update(isEmailValid: isEmailValid(email)));
  }

  void submit(String email) async {
    emit(SubscribeState.loading());
    var emailValid = isEmailValid(email);
    if (emailValid) {
      try {
        await _repository.subscribeEmail(email);
        emit(SubscribeState.success());
      } catch (e) {
        emit(SubscribeState.failure(isEmailValid: emailValid, isFailure: true));
      }
    } else {
      emit(SubscribeState.failure(isEmailValid: emailValid, isFailure: false));
    }
  }

  bool isEmailValid(String email) {
    final RegExp _emailPattern = RegExp(
      '^[a-zA-Z0-9.!#\$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\$',
    );
    return _emailPattern.hasMatch(email);
  }
}
