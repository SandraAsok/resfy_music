import 'package:hive/hive.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:resfy_music/db/models/mostplayed.dart';
import 'package:resfy_music/db/models/recentlyplayed.dart';

late Box<Favourites> favouritesdb;
openFavouritesDB() async {
  favouritesdb = await Hive.openBox<Favourites>('favourites');
}

late Box<MostPlayed> mostplayedsongs;
openmostplayeddb() async {
  mostplayedsongs = await Hive.openBox("Mostplayed");
}

updatePlayedSongsCount(MostPlayed value, int index) {
  final box = MostplayedBox.getInstance();
  List<MostPlayed> list1 = box.values.toList();
  bool isAlready =
      list1.where((element) => element.songname == value.songname).isEmpty;
  if (isAlready == true) {
    box.add(value);
  } else {
    int index =
        list1.indexWhere((element) => element.songname == value.songname);
    box.deleteAt(index);
    box.put(index, value);
  }
  int count = value.count;
  value.count = count + 1;
}

late Box<RecentlyPlayed> recentlyPlayedBox;
openrecentlyplayeddb() async {
  recentlyPlayedBox = await Hive.openBox("recentlyplayed");
}

updaterecentlyplayed(RecentlyPlayed value) {
  List<RecentlyPlayed> list = recentlyPlayedBox.values.toList();
  bool isalready =
      list.where((element) => element.songname == value.songname).isEmpty;
  if (isalready == true) {
    recentlyPlayedBox.add(value);
  } else {
    int index =
        list.indexWhere((element) => element.songname == value.songname);
    recentlyPlayedBox.deleteAt(index);
    recentlyPlayedBox.add(value);
  }
}
