part of 'result_bloc.dart';

// State
abstract class ResultState extends Equatable {
  @override
  List<Object> get props => [];
}

class ResultInitial extends ResultState {}

class ResultLoading extends ResultState {}

class ResultSuccess extends ResultState {
  final Bill bill;

  ResultSuccess(this.bill);
}

class ResultFailure extends ResultState {
  final String error;

  ResultFailure(this.error);

  @override
  List<Object> get props => [error];
}
