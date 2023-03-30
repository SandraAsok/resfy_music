import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/mostplayed.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/screens/homescreen.dart';

import 'db/functions/dbfunctions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final box = SongBox.getInstance();
  List<SongModel> fetchsongs = [];
  List<SongModel> allsongs = [];
  final mostbox = MostplayedBox.getInstance();
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSplashScreen(
          splashIconSize: 250,
          backgroundColor: splashcolor,
          splashTransition: SplashTransition.scaleTransition,
          splash: const Image(image: AssetImage('assets/logo.png')),
          nextScreen: const MyHomePage(),
        ),
      ),
    );
  }

  //request permission
  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool status = await audioQuery.permissionsStatus();

      if (!status) {
        await audioQuery.permissionsRequest();

        fetchsongs = await audioQuery.querySongs();
        for (var element in fetchsongs) {
          if (element.fileExtension == 'mp3') {
            allsongs.add(element);
          }
        }

        for (var element in allsongs) {
          await box.add(Songs(
              songname: element.title,
              duration: element.duration,
              id: element.id,
              songurl: element.uri));
        }

        for (var element in allsongs) {
          mostbox.add(MostPlayed(
            songname: element.title,
            songurl: element.uri!,
            duration: element.duration!,
            count: 0,
            id: element.id,
          ));
        }
      }
      if (!mounted) return;

      setState(() {});
    }
  }
}
