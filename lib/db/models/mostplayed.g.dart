// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mostplayed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MostPlayedAdapter extends TypeAdapter<MostPlayed> {
  @override
  final int typeId = 5;

  @override
  MostPlayed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MostPlayed(
      songname: fields[0] as String,
      songurl: fields[2] as String,
      duration: fields[1] as int,
      count: fields[3] as int,
      id: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MostPlayed obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.songurl)
      ..writeByte(3)
      ..write(obj.count)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MostPlayedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
