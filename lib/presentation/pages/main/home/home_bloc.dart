import 'dart:convert';

import 'package:android_tv_my/data/bloc/base_state.dart';
import 'package:android_tv_my/data/model/location_model.dart';
import 'package:android_tv_my/data/model/tv_app_model.dart';
import 'package:android_tv_my/data/model/weather_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, BaseState> {
  static const _channel = MethodChannel('tv_apps_channel');

  List<TvAppModel> tvAppsList = [];
  LocationModel? _currentLocation;
  List<WeatherModel> weatherList = [];

  HomeBloc() : super(InitialState()) {
    on<InitEvent>((event, emit) async {
      add(LoadTvAppsEvent());
      add(CurrentLocationEvent());
    });
    on<LoadTvAppsEvent>((event, emit) async {
      await _loadData(emit);
    });
    on<CurrentLocationEvent>((event, emit) async {
      await _loadCurrentLocation(emit);
    });
    on<LoadForecastEvent>((event, emit) async {
      await _loadForecast(emit);
    });
    on<LaunchAppEvent>((event, emit) async {
      await _launchApp(emit, event.packageName);
    });
  }

  Future<void> _loadData(Emitter<BaseState> emit) async {
    emit(ShowLoadingState(true));

    try {
      final response = await _getTvApps();
      emit(ShowLoadingState(false));
      if (response.isNotEmpty) {
        tvAppsList = response;
        emit(SuccessLoadState());
      }
    } catch (e) {
      emit(ShowLoadingState(false));
      emit(ShowErrorMessage(e.toString()));
    }
  }

  static Future<List<TvAppModel>> _getTvApps() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;

      final List<dynamic> rawApps = await _channel.invokeMethod('getTvApps');
      return rawApps
          .map((e) => TvAppModel.fromJson((e as Map).cast<String, dynamic>()))
          .where((app) => app.name != appName)
          .toList();
    } catch (e) {
      debugPrint("$e");
      throw Exception("TV apps fetch error: $e");
    }
  }

  Future<void> _loadCurrentLocation(Emitter<BaseState> emit) async {
    try {
      emit(ShowCurrentLocationState(true));
      final response = await http.get(Uri.parse("https://ipwho.is/"));
      emit(ShowCurrentLocationState(false));
      if (response.statusCode == 200) {
        _currentLocation = LocationModel.fromJson(json.decode(response.body));
        add(LoadForecastEvent());
      } else {
        debugPrint("GGQ => _loadCurrentLocation ${response.reasonPhrase ?? "Error"}");
        emit(ShowErrorMessage(response.reasonPhrase ?? "Error"));
      }
    } catch (e) {
      emit(ShowCurrentLocationState(false));
      _currentLocation = LocationModel(41.2994958, 69.2400734);
      // emit(ShowErrorMessage("Location olishda xatolik: $e"));
      print('Location olishda xatolik: $e');
    }
  }

  Future<void> _loadForecast(Emitter<BaseState> emit) async {
    try {
      emit(ShowLoadingForecastState(true));
      final response = await http.get(Uri.parse(
          "https://api.open-meteo.com/v1/forecast?latitude=${_currentLocation?.latitude ?? 41.2994958}2&longitude=${_currentLocation?.longitude ?? 69.2400734}&daily=apparent_temperature_mean,wind_speed_10m_max,weather_code"));
      emit(ShowLoadingForecastState(false));
      if (response.statusCode == 200) {
        weatherList = _parseWeather(json.decode(response.body));
        emit(LoadedForecastState());
      } else {
        debugPrint("GGQ => _loadForecast ${response.reasonPhrase ?? "Error"}");
        emit(ShowErrorMessage(response.reasonPhrase ?? "Error"));
      }
    } catch (e) {
      emit(ShowLoadingForecastState(false));
      emit(ShowErrorMessage("Ma'lumot olishda xatolik: $e"));

      print("Ma'lumot olishda xatolik: $e");
    }
  }

  Future<void> _launchApp(Emitter<BaseState> emit, String packageName) async {
    try {
      final bool result = await _channel.invokeMethod('launchApp', {'packageName': packageName});

      if (!result) {
        emit(ShowErrorMessage("Could not launch app"));
      }
    } catch (e) {
      debugPrint('Error opening app: $e');
      emit(ShowErrorMessage("Error opening app: $e"));
    }
  }
}

List<WeatherModel> _parseWeather(dynamic json) {
  final daily = json['daily'];
  final times = List<String>.from(daily['time']);
  final temps = List<double>.from(daily['apparent_temperature_mean']);
  final windMax = List<double>.from(daily['wind_speed_10m_max']);
  final weatherCodes = List<int>.from(daily['weather_code']);

  List<WeatherModel> result = [];

  for (int i = 0; i < times.length; i++) {
    result.add(
      WeatherModel(
        times[i],
        temps[i],
        windMax[i],
        weatherCodes[i],
      ),
    );
  }

  return result;
}
