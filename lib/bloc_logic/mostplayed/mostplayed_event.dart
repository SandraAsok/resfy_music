part of 'mostplayed_bloc.dart';

@immutable
abstract class MostplayedEvent {}

class FetchMostPlayed extends MostplayedEvent {
  FetchMostPlayed();
}

class UpdateMostPlayedCount extends MostplayedEvent {
  final MostPlayed mostplay;
  final int index;

  UpdateMostPlayedCount(this.mostplay, this.index);

  List<Object> get props => [mostplay, index];
}

// class ClearMostPlayed extends MostplayedEvent {
//   final int index;

//   ClearMostPlayed(this.index);

//   List<Object> get props => [index];
// }
