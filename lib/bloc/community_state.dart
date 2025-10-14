part of 'community_cubit.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object> get props => [];
}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityLoadSuccess extends CommunityState {
  final List<Post> posts;

  const CommunityLoadSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class CommunityLoadFailure extends CommunityState {
  final String error;

  const CommunityLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CommunitySubmitting extends CommunityState {}
class CommunitySubmitSuccess extends CommunityState {}
class CommunitySubmitFailure extends CommunityState {
  final String error;
  const CommunitySubmitFailure(this.error);
  @override
  List<Object> get props => [error];
}