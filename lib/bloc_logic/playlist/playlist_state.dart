part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {
  List<Object> get props => [];
}

class DisplayPlaylist extends PlaylistState {
  final List<PlaylistSongs> Playlist;
  DisplayPlaylist(this.Playlist);

  List<Object> get props => [Playlist];
}
