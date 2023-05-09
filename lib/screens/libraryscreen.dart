import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/screens/likedscreen.dart';
import 'package:resfy_music/screens/mostplayedscreen.dart';
import 'package:resfy_music/screens/playlistscreen.dart';
import 'package:resfy_music/screens/recentscreen.dart';

class LibraryScreen extends StatelessWidget {
  LibraryScreen({super.key});

  final box = SongBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        children: [
          const SizedBox(height: 25),
          ListTile(
            tileColor: tilecolor,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: ((context) => Liked())));
            },
            leading: const Icon(Icons.favorite, color: iconcolor, size: 25),
            title:
                const Text('Liked Songs', style: TextStyle(color: fontcolor)),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: tilecolor,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: ((context) => Recent())));
            },
            leading: const Icon(Icons.queue_music, color: iconcolor, size: 25),
            title: const Text('Recently Played',
                style: TextStyle(color: fontcolor)),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: tilecolor,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => MostPlayedScreen())));
            },
            leading: const Icon(Icons.queue_music, color: iconcolor, size: 25),
            title: const Text(
              'Most Played',
              style: TextStyle(color: fontcolor),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: tilecolor,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => PlayListScreen())));
            },
            leading: const Icon(Icons.playlist_add, color: iconcolor, size: 25),
            title: const Text(
              'Playlists',
              style: TextStyle(color: fontcolor),
            ),
          ),
        ],
      ),
    );
  }
}
