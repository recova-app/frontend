part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final User user;
  final Statistics statistics;

  const HomeLoadSuccess({required this.user, required this.statistics});

  @override
  List<Object> get props => [user, statistics];
}

class HomeLoadFailure extends HomeState {
  final String error;

  const HomeLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}