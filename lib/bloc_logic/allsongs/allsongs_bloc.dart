// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:resfy_music/db/models/songmodel.dart';

part 'allsongs_event.dart';
part 'allsongs_state.dart';

class AllsongsBloc extends Bloc<AllsongsEvent, AllsongsState> {
  AllsongsBloc() : super(AllsongsInitial()) {
    on<FetchAllSongs>((event, emit) {
      try {
        final alldbsongs = SongBox.getInstance();
        List<Songs> allDbsongs = alldbsongs.values.toList();
        emit(DisplayAllSongs(allDbsongs));
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
