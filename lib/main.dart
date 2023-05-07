import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resfy_music/bloc_logic/allsongs/allsongs_bloc.dart';
import 'package:resfy_music/bloc_logic/favourites/favourites_bloc.dart';
import 'package:resfy_music/bloc_logic/mostplayed/mostplayed_bloc.dart';
import 'package:resfy_music/bloc_logic/playlist/playlist_bloc.dart';
import 'package:resfy_music/bloc_logic/recentlyplayed/recentlyplayed_bloc.dart';
import 'package:resfy_music/db/functions/dbfunctions.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:resfy_music/db/models/mostplayed.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/db/models/recentlyplayed.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>(boxname);

  Hive.registerAdapter(FavouritesAdapter());
  await Hive.openBox<Favourites>(boxname2);
  openFavouritesDB();

  Hive.registerAdapter(PlaylistSongsAdapter());
  await Hive.openBox<PlaylistSongs>('playlist');

  Hive.registerAdapter(MostPlayedAdapter());
  await Hive.openBox<MostPlayed>('MostPlayed');
  openmostplayeddb();

  Hive.registerAdapter(RecentlyPlayedAdapter());
  openrecentlyplayeddb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AllsongsBloc(),
        ),
        BlocProvider(
          create: (context) => FavouritesBloc(),
        ),
        BlocProvider(
          create: (context) => MostplayedBloc(),
        ),
        BlocProvider(
          create: (context) => PlaylistBloc(),
        ),
        BlocProvider(
          create: ((context) => RecentlyplayedBloc()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
