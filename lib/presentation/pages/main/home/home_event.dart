abstract class HomeEvent {}

class InitEvent extends HomeEvent {}

class LoadTvAppsEvent extends HomeEvent {}

class CurrentLocationEvent extends HomeEvent {}

class LoadForecastEvent extends HomeEvent {}

class LaunchAppEvent extends HomeEvent {
  final String packageName;

  LaunchAppEvent(this.packageName);
}
