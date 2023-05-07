import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resfy_music/db/functions/dbfunctions.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/splash.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc() : super(FavouritesInitial()) {
    on<FetchFavSongs>((event, emit) {
      try {
        final favbox = Favouritesbox.getinstance();
        List<Favourites> favourite = favbox.values.toList();
        emit(DisplayFavSongs(favourite));
      } catch (e) {
        log(e.toString());
      }
    });

    on<AddorRemoveFavourites>((event, emit) {
      List<Songs> dbsongs = box.values.toList();
      final favbox = Favouritesbox.getinstance();
      final favouritesongs = favouritesdb.values.toList();
      bool isalready = favouritesongs
          .where((element) => element.songname == dbsongs[event.index].songname)
          .isEmpty;
      if (isalready) {
        favouritesdb.add(event.favsong);
        add(FetchFavSongs());
      } else {
        int index = favouritesongs.indexWhere(
            (element) => element.songname == event.favsong.songname);
        favbox.deleteAt(index);
        add(FetchFavSongs());
      }
    });

    on<RemoveFromFavouritesList>((event, emit) {
      try {
        final favbox = Favouritesbox.getinstance();
        favbox.deleteAt(event.index);
        add(FetchFavSongs());
      } on Exception catch (e) {
        log(e.toString());
      }
    });
  }
}
