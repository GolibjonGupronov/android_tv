import 'package:bloc/bloc.dart';

import '../../../../data/bloc/base_state.dart';
import 'splash_event.dart';

class SplashBloc extends Bloc<SplashEvent, BaseState> {
  SplashBloc() : super(InitialState()) {
    on<InitEvent>((event, emit) async {
      await Future.delayed(Duration(seconds: 2));
      emit(SuccessLoadState());
    });
  }
}
