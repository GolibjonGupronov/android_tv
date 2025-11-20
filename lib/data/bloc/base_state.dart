import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseState extends Equatable {
  @override
  List<Object?> get props => [UniqueKey()];
}

class InitialState extends BaseState {}

class ShowLoadingState extends BaseState {
  final bool show;

  ShowLoadingState(this.show);
}

class SuccessLoadState extends BaseState {}

class ShowErrorMessage extends BaseState {
  final String message;

  ShowErrorMessage(this.message);
}
