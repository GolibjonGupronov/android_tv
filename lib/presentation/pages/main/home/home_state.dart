import 'package:android_tv_my/data/bloc/base_state.dart';

abstract class HomeState extends BaseState {}

class ShowCurrentLocationState extends HomeState {
  final bool show;

  ShowCurrentLocationState(this.show);
}

class ShowLoadingForecastState extends HomeState {
  final bool show;

  ShowLoadingForecastState(this.show);
}

class LoadedForecastState extends HomeState {}
