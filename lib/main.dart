import 'package:flutter/material.dart';
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

  Hive.registerAdapter(RecentlyPlayedAdapter());
  openrecentlyplayeddb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: SplashScreen(),
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
