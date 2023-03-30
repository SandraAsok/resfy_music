import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/screens/nowplayingscreen.dart';

class NowPlayingSlider extends StatefulWidget {
  const NowPlayingSlider({super.key});

  static int? index = 0;
  static ValueNotifier<int> enteredvalue = ValueNotifier(index!);

  @override
  State<NowPlayingSlider> createState() => _NowPlayingSliderState();
}

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

class _NowPlayingSliderState extends State<NowPlayingSlider> {
  final box = SongBox.getInstance();
  List<Audio> convertaudio = [];

  @override
  void initState() {
    List<Songs> dbsongs = box.values.toList();
    for (var item in dbsongs) {
      convertaudio.add(Audio.file(item.songurl!,
          metas: Metas(title: item.songname, id: item.id.toString())));
    }
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double vertwidth = MediaQuery.of(context).size.width;
    double vertheight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
      valueListenable: NowPlayingSlider.enteredvalue,
      builder: ((BuildContext context, int value, child) {
        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: ((context, Box<Songs> allsongbox, child) {
            List<Songs> alldbsongs = allsongbox.values.toList();
            if (alldbsongs.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return InkWell(
              onTap: () {
                NowPlayingScreen.nowplayingindex.value = value;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => NowPlayingScreen())));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: bgcolor, borderRadius: BorderRadius.circular(5)),
                width: vertwidth,
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QueryArtworkWidget(
                      quality: 100,
                      artworkWidth: vertwidth * 0.16,
                      artworkHeight: vertheight * 0.16,
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(10),
                      id: alldbsongs[value].id!,
                      type: ArtworkType.AUDIO,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: vertwidth * 0.5,
                          child: Text(
                            alldbsongs[value].songname!,
                            style:
                                const TextStyle(fontSize: 18, color: fontcolor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    PlayerBuilder.isPlaying(
                        player: player,
                        builder: ((context, isPlaying) {
                          return Padding(
                            padding: EdgeInsets.only(right: vertwidth * 0.01),
                            child: Wrap(
                              spacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                SizedBox(
                                  width: 35,
                                  height: 50,
                                  child: IconButton(
                                      onPressed: () {
                                        previousMusic(
                                            player, value, alldbsongs);
                                      },
                                      icon: const Icon(Icons.skip_previous,
                                          color: iconcolor, size: 30)),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 35,
                                  child: IconButton(
                                    icon: AnimatedCrossFade(
                                      duration:
                                          const Duration(milliseconds: 300),
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
                                    onPressed: () {
                                      if (isPlaying) {
                                        player.stop();
                                      } else {
                                        playorpause(player, value, alldbsongs);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  height: 50,
                                  child: IconButton(
                                      onPressed: () {
                                        skipMusic(player, value, alldbsongs);
                                      },
                                      icon: const Icon(Icons.skip_next,
                                          color: iconcolor, size: 30)),
                                )
                              ],
                            ),
                          );
                        }))
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  void previousMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.open(
      Audio.file(dbsongs[index - 1].songurl!),
      showNotification: true,
    );
    setState(() {
      NowPlayingSlider.enteredvalue.value--;
    });
    await player.stop();
  }

  void skipMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.open(
      Audio.file(dbsongs[index + 1].songurl!),
      showNotification: true,
    );
    setState(() {
      NowPlayingSlider.enteredvalue.value++;
    });
    await player.stop();
  }

  void playorpause(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.open(
      Audio.file(dbsongs[index].songurl!),
      showNotification: true,
    );
    setState(() {
      NowPlayingSlider.enteredvalue.value;
    });
    await player.stop();
  }
}
