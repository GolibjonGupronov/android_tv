import 'dart:ui';

import 'package:android_tv_my/data/bloc/base_state.dart';
import 'package:android_tv_my/presentation/ui/widget/tv_app_item_view.dart';
import 'package:android_tv_my/presentation/ui/widget/weather_item_view.dart';
import 'package:android_tv_my/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/assets.dart';
import '../../../ui/shimmer/weather_item_shimmer.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);

    return BlocListener<HomeBloc, BaseState>(
      listener: (context, state) {
        if (state is ShowErrorMessage) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
      child: WillPopScope(
        onWillPop: ()async{
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Assets.imagesBackground.image(fit: BoxFit.cover, width: context.getScreenWidth),
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
                      color: Colors.grey.withValues(alpha: 0.2),
                      child: SizedBox(width: context.getScreenWidth, height: context.getScreenHeight))),
              CustomScrollView(
                controller: ScrollController(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: BlocBuilder<HomeBloc, BaseState>(
                      buildWhen: (p, current) =>
                          current is ShowCurrentLocationState ||
                          current is ShowLoadingForecastState ||
                          current is LoadedForecastState,
                      builder: (context, state) {
                        bool progress =
                            (state is ShowCurrentLocationState && state.show) || (state is ShowLoadingForecastState && state.show);
                        return (_check(bloc.weatherList, progress))
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Weather forecast", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          if (progress) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: WeatherItemShimmer(),
                                            );
                                          }
                                          final item = bloc.weatherList[index];
                                          return WeatherItemView(item: item, index: index);
                                        },
                                        itemCount: progress ? 7 : bloc.weatherList.length),
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: BlocBuilder<HomeBloc, BaseState>(
                      buildWhen: (p, current) => current is ShowLoadingState || current is SuccessLoadState,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("APPS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 140,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final item = bloc.tvAppsList[index];
                                    return TvAppItemView(
                                        item: item,
                                        onTap: () {
                                          bloc.add(LaunchAppEvent(item.package));
                                        });
                                  },
                                  separatorBuilder: (c, i) => SizedBox(width: 20),
                                  itemCount: bloc.tvAppsList.length),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

bool _check(List list, bool progress) {
  return list.isEmpty && !progress;
}
