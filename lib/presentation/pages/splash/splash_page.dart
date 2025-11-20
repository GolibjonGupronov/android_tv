import 'package:android_tv_my/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/bloc/base_state.dart';
import '../../../../generated/assets.dart';
import '../main/home/home_page.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SplashBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<SplashBloc>(context);

    return BlocListener<SplashBloc, BaseState>(
      listener: (context, state) {
        if (state is SuccessLoadState) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
        }
      },
      child: Scaffold(
        body: Stack(children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(Assets.imagesLogo, fit: BoxFit.fill),
          ),
          Positioned(bottom: 50, left: context.getScreenWidth / 2, child: CupertinoActivityIndicator())
        ]),
      ),
    );
  }
}
