import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/db/models/songmodel.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistInitial()) {
    on<FetchPlaylistSongs>((event, emit) {
      try {
        final playlistbox = PlaylistSongsbox.getInstance();
        List<PlaylistSongs> playlistsong = playlistbox.values.toList();
        emit(DisplayPlaylist(playlistsong));
      } catch (e) {
        log(e.toString());
      }
    });

    on<AddtoPlaylist>((event, emit) {
      try {
        final songbox = SongBox.getInstance();
        final playbox = PlaylistSongsbox.getInstance();

        List<PlaylistSongs> playlistDB = playbox.values.toList();
        PlaylistSongs? playsongs = playbox.getAt(event.index);
        List<Songs> playsongdb = playsongs!.playlistssongs!;
        List<Songs> songdb = songbox.values.toList();
        bool isAlreadyAdded =
            playsongdb.any((element) => element.id == songdb[event.index].id);
        if (!isAlreadyAdded) {
          playsongdb.add(Songs(
            songname: songdb[event.index].songname,
            duration: songdb[event.index].duration,
            id: songdb[event.index].id,
            songurl: songdb[event.index].songurl,
          ));
        }
        playbox.putAt(
            event.index,
            PlaylistSongs(
                playlistname: playlistDB[event.index].playlistname,
                playlistssongs: playsongdb));
      } catch (e) {
        log(e.toString());
      }
    });

    on<CreatePlaylist>((event, emit) {
      final box1 = PlaylistSongsbox.getInstance();
      List<Songs> songsplaylist = [];
      try {
        box1.add(PlaylistSongs(
            playlistname: event.title, playlistssongs: songsplaylist));
        add(FetchPlaylistSongs());
      } on Exception catch (e) {
        log(e.toString());
      }
    });

    on<DeletePlaylistSong>((event, emit) {
      final box1 = PlaylistSongsbox.getInstance();
      box1.deleteAt(event.index);
    });

    on<DeletePlaylist>((event, emit) {
      final box1 = PlaylistSongsbox.getInstance();
      box1.deleteAt(event.index);
      add(FetchPlaylistSongs());
    });

    on<EditPlaylist>((event, emit) {
      final playlistbox = PlaylistSongsbox.getInstance();
      List<PlaylistSongs> playlistsong = playlistbox.values.toList();
      final box1 = PlaylistSongsbox.getInstance();

      box1.putAt(
          event.index,
          PlaylistSongs(
              playlistname: event.title,
              playlistssongs: playlistsong[event.index].playlistssongs));
      add(FetchPlaylistSongs());
    });
  }
}
