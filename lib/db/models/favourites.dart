import 'package:hive/hive.dart';
part 'favourites.g.dart';

@HiveType(typeId: 2)
class Favourites {
  @HiveField(0)
  String? songname;

  @HiveField(1)
  int? duration;

  @HiveField(2)
  String? songurl;

  @HiveField(3)
  int? id;

  Favourites({
    required this.songname,
    required this.duration,
    required this.songurl,
    required this.id,
  });
}

String boxname2 = 'favourites';

class Favouritesbox {
  static Box<Favourites>? _box;
  static Box<Favourites> getinstance() {
    return _box ??= Hive.box(boxname2);
  }
}
