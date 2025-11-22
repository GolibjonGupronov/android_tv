import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/bloc/base_state.dart';
import '../../../data/services/kiosk_service.dart';
import 'splash_event.dart';

class SplashBloc extends Bloc<SplashEvent, BaseState> {
  SplashBloc() : super(InitialState()) {
    on<InitEvent>((event, emit) async {
      await _checkOwner();
      await Future.delayed(Duration(seconds: 1));
      emit(SuccessLoadState());
    });
  }

  Future<void> _checkOwner() async {
    final isOwner = await KioskService.isDeviceOwner();
    debugPrint("GGQ => $isOwner");
    if (isOwner) {
      await KioskService.setLockPackages(<String>['com.example.android_tv_my']);
      await KioskService.startLockTask();
      // await KioskService.stopLockTask();
    } else {
    }
  }
}
