import 'package:hive/hive.dart';
part 'mostplayed.g.dart';

@HiveType(typeId: 5)
class MostPlayed {
  @HiveField(0)
  String songname;
  @HiveField(1)
  int duration;
  @HiveField(2)
  String songurl;
  @HiveField(3)
  int count;
  @HiveField(4)
  int id;

  MostPlayed(
      {required this.songname,
      required this.songurl,
      required this.duration,
      required this.count,
      required this.id});
}

class MostplayedBox {
  static Box<MostPlayed>? _box;
  static Box<MostPlayed> getInstance() {
    return _box ??= Hive.box('Mostplayed');
  }
}
