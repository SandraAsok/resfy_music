import 'package:resfy_music/db/functions/dbfunctions.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:resfy_music/db/models/songmodel.dart';

addToFavourites(int index) async {
  final box = SongBox.getInstance();
  List<Songs> dbsongs = box.values.toList();
  List<Favourites> favouritessongs = [];
  favouritessongs = favouritesdb.values.toList();
  bool isalready = favouritessongs
      .where((element) => element.songname == dbsongs[index].songname)
      .isEmpty;
  if (isalready) {
    favouritesdb.add(Favourites(
        songname: dbsongs[index].songname,
        duration: dbsongs[index].duration,
        songurl: dbsongs[index].songurl,
        id: dbsongs[index].id));
  } else {
    favouritessongs
        .where((element) => element.songname == dbsongs[index].songname)
        .isEmpty;
    int currentindex = favouritessongs
        .indexWhere((element) => element.id == dbsongs[index].id);
    await favouritesdb.deleteAt(currentindex);
    // await favouritesdb.deleteAt(index);
  }
}

removefavourite(int index) async {
  final box = SongBox.getInstance();
  final box4 = Favouritesbox.getinstance();
  List<Favourites> favsongs = box4.values.toList();
  List<Songs> dbsongs = box.values.toList();
  int currentindex =
      favsongs.indexWhere((element) => element.id == dbsongs[index].id);
  await favouritesdb.deleteAt(currentindex);
}

deletefavourite(int index) async {
  await favouritesdb.deleteAt(favouritesdb.length - index - 1);
}

// ignore: avoid_types_as_parameter_names, non_constant_identifier_names
bool checkFavoriteStatus(int index, BuildContext) {
  final box = SongBox.getInstance();
  List<Favourites> favouritessongs = [];
  List<Songs> dbsongs = box.values.toList();
  Favourites value = Favourites(
      songname: dbsongs[index].songname,
      duration: dbsongs[index].duration,
      songurl: dbsongs[index].songurl,
      id: dbsongs[index].id);

  favouritessongs = favouritesdb.values.toList();
  bool isAlreadyThere = favouritessongs
      .where((element) => element.songname == value.songname)
      .isEmpty;
  return isAlreadyThere ? true : false;
}
