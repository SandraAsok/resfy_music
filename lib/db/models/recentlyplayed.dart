import 'package:hive/hive.dart';
part 'recentlyplayed.g.dart';

@HiveType(typeId: 3)
class RecentlyPlayed {
  @HiveField(0)
  String? songname;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;
  @HiveField(5)
  int? index;
  RecentlyPlayed(
      {this.songname,
      this.duration,
      this.songurl,
      required this.id,
      required this.index});
}

String boxname3 = 'RecentlyPlayed';

class RecentlyPlayedBox {
  static Box<RecentlyPlayed>? _box;
  static Box<RecentlyPlayed> getInstance() {
    return _box ??= Hive.box(boxname3);
  }
}
