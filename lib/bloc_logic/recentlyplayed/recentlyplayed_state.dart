part of 'recentlyplayed_bloc.dart';

@immutable
abstract class RecentlyplayedState {}

class RecentlyplayedInitial extends RecentlyplayedState {
  List<Object> get props => [];
}

// ignore: must_be_immutable
class DisplayRecentlyPlayed extends RecentlyplayedState {
  List<RecentlyPlayed> recentPlay;
  DisplayRecentlyPlayed(this.recentPlay);

  List<Object> get props => [recentPlay];
}
