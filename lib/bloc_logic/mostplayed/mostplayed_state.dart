part of 'mostplayed_bloc.dart';

@immutable
abstract class MostplayedState {}

class MostplayedInitial extends MostplayedState {
  List<Object> get props => [];
}

class DisplayMostPlayed extends MostplayedState {
  final List<MostPlayed> mostplayed;
  DisplayMostPlayed(this.mostplayed);

  List<Object> get props => [mostplayed];
}
