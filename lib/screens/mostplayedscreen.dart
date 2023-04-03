import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/mostplayed.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';

class MostPlayedScreen extends StatefulWidget {
  const MostPlayedScreen({super.key});

  @override
  State<MostPlayedScreen> createState() => _MostPlayedScreenState();
}

class _MostPlayedScreenState extends State<MostPlayedScreen> {
  final box = MostplayedBox.getInstance();
  final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
  List<Audio> songs = [];
  @override
  void initState() {
    List<MostPlayed> songlist = box.values.toList();

    int i = 0;
    for (var item in songlist) {
      if (item.count > 3) {
        mostfinalsong.insert(i, item);
        i++;
      }
    }
    for (var items in mostfinalsong) {
      songs.add(Audio.file(items.songurl,
          metas: Metas(title: items.songname, id: items.id.toString())));
    }
    super.initState();
  }

  List<MostPlayed> mostfinalsong = [];
  @override
  Widget build(BuildContext context) {
    double vertheight = MediaQuery.of(context).size.height;
    return Container(
      color: bgcolor,
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
                            color: iconcolor,
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
                    'Most Played',
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
                              player.open(
                                Playlist(audios: songs, startIndex: 0),
                                showNotification: true,
                              );
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
                    }),
                  ),
                ),
                ValueListenableBuilder<Box<MostPlayed>>(
                  valueListenable: box.listenable(),
                  builder: (context, Box<MostPlayed> mostplayedDB, child) {
                    return mostfinalsong.isNotEmpty
                        ? (ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: mostfinalsong.length,
                            itemBuilder: ((context, index) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 5),
                                  child: ListTile(
                                    onTap: () {
                                      player.open(
                                        Playlist(
                                            audios: songs, startIndex: index),
                                        headPhoneStrategy: HeadPhoneStrategy
                                            .pauseOnUnplugPlayOnPlug,
                                        showNotification: true,
                                      );
                                    },
                                    leading: QueryArtworkWidget(
                                      artworkHeight: vertheight * 0.06,
                                      artworkWidth: vertheight * 0.06,
                                      keepOldArtwork: true,
                                      artworkBorder: BorderRadius.circular(10),
                                      id: mostfinalsong[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/logo.png',
                                          height: vertheight * 0.06,
                                          width: vertheight * 0.06,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      mostfinalsong[index].songname,
                                      style: const TextStyle(color: fontcolor),
                                    ),
                                  ),
                                )),
                          ))
                        : const Center(
                            child: Text(
                              "Your most played songs!",
                              style: TextStyle(color: fontcolor),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
          bottomSheet: NowPlayingSlider(),
        ),
      ),
    );
  }
}
