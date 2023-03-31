import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/functions/dbfunctions.dart';
import 'package:resfy_music/db/models/recentlyplayed.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/screens/likedscreen.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  final _audioPlayer = AssetsAudioPlayer.withId('0');

  final List<RecentlyPlayed> recentplay = [];
  final box = RecentlyPlayedBox.getInstance();
  List<Audio> rcentplay = [];
  @override
  void initState() {
    final List<RecentlyPlayed> recentlyplayed =
        box.values.toList().reversed.toList();
    for (var item in recentlyplayed) {
      rcentplay.add(
        Audio.file(
          item.songurl.toString(),
          metas: Metas(
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double vheight = MediaQuery.of(context).size.height;
    return Container(
      color: appbarcolor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: bgcolor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: tilecolor,
                              borderRadius: BorderRadius.circular(30)),
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                              ),
                            ),
                            color: tilecolor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                    title: const Text(
                      'Recently Played',
                      style: TextStyle(fontSize: 20, color: fontcolor),
                    ),
                    trailing: PlayerBuilder.isPlaying(
                        player: player,
                        builder: ((context, isPlaying) {
                          return Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: tilecolor),
                            child: IconButton(
                              onPressed: () {
                                if (isPlaying) {
                                  player.stop();
                                } else {
                                  _audioPlayer.open(
                                      Playlist(
                                          audios: rcentplay, startIndex: 0),
                                      showNotification: true,
                                      headPhoneStrategy:
                                          HeadPhoneStrategy.pauseOnUnplug,
                                      loopMode: LoopMode.playlist);
                                }
                              },
                              icon: AnimatedCrossFade(
                                duration: const Duration(milliseconds: 300),
                                firstChild: const Icon(
                                  Icons.play_arrow,
                                  color: iconcolor,
                                  size: 25,
                                ),
                                secondChild: const Icon(
                                  Icons.pause,
                                  color: iconcolor,
                                  size: 25,
                                ),
                                crossFadeState: isPlaying
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                              ),
                            ),
                          );
                        }))),
                ValueListenableBuilder<Box<RecentlyPlayed>>(
                  valueListenable: recentlyPlayedBox.listenable(),
                  // ignore: non_constant_identifier_names
                  builder: ((context, RecentDB, child) {
                    // ignore: non_constant_identifier_names
                    List<RecentlyPlayed> Recentplayed =
                        RecentDB.values.toList().reversed.toList();
                    return Recentplayed.isNotEmpty
                        ? (ListView.builder(
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: Recentplayed.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8.0, left: 5),
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    keepOldArtwork: true,
                                    artworkBorder: BorderRadius.circular(10),
                                    id: Recentplayed[index].id!,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        height: vheight * 0.06,
                                        width: vheight * 0.06,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    Recentplayed[index].songname!,
                                    style: const TextStyle(color: fontcolor),
                                  ),
                                  onTap: () {
                                    _audioPlayer.open(
                                        Playlist(
                                            audios: rcentplay,
                                            startIndex: index),
                                        showNotification: true,
                                        headPhoneStrategy:
                                            HeadPhoneStrategy.pauseOnUnplug,
                                        loopMode: LoopMode.playlist);
                                  },
                                ),
                              );
                            }),
                          ))
                        : Padding(
                            padding: EdgeInsets.only(top: vheight * 0.3),
                            child: const Text(
                              "You Have't played any songs",
                              style: TextStyle(color: fontcolor),
                            ),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
