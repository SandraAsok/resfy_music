import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/screens/nowplayingscreen.dart';

// ignore: must_be_immutable
class NowPlayingSlider extends StatefulWidget {
  const NowPlayingSlider({super.key});

  static int? index = 0;
  static ValueNotifier<int> enteredvalue = ValueNotifier<int>(index!);

  @override
  State<NowPlayingSlider> createState() => _NowPlayingSliderState();
}

AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

class _NowPlayingSliderState extends State<NowPlayingSlider> {
  final box = SongBox.getInstance();
  //List<Songs> dbsongs = box.values.toList();
  // bool istaped = false;
  List<Audio> convertAudios = [];
  @override
  void initState() {
    List<Songs> dbsongs = box.values.toList();
    for (var i in dbsongs) {
      int j = 0;
      print("jafhahdfahdfj ${dbsongs[j].songname}");
      j++;
      convertAudios.add(Audio.file(
        i.songurl!,
        metas: Metas(
          title: i.songname,
          id: i.id.toString(),
        ),
      ));
    }
    // audioPlayer.open(
    //     Playlist(
    //       audios: convertAudios,
    //     ),
    //     showNotification: true,
    //     autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;

    return audioPlayer.builderCurrent(
      builder: (context, playing) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: bgcolor, borderRadius: BorderRadius.circular(20)),
              width: vwidth,
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QueryArtworkWidget(
                    quality: 100,
                    artworkWidth: vwidth * 0.16,
                    artworkHeight: vheight * 0.16,
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(10),
                    id: int.parse(playing.audio.audio.metas.id!),
                    type: ArtworkType.AUDIO,
                    // nullArtworkWidget: ClipRRect(
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: Image.asset(
                    //       'assets/images/music.jpeg',
                    //       height: vheight * 0.16,
                    //       width: vheight * 0.16,
                    //     ),
                    //   ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: vwidth * 0.4,
                        child: Text(
                          // allDbdongs[value].songname!,
                          audioPlayer.getCurrentAudioTitle,
                          style: TextStyle(fontSize: 18, color: fontcolor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: vwidth * 0.4,
                        child: Text(
                          // allDbdongs[value].artist ?? "No Artist",
                          audioPlayer.getCurrentAudioArtist,
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  PlayerBuilder.isPlaying(
                    player: audioPlayer,
                    builder: ((context, isPlaying) {
                      return Padding(
                        padding: EdgeInsets.only(right: vwidth * 0.01),
                        child: Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: tilecolor),
                              child: IconButton(
                                onPressed: () async {
                                  await audioPlayer.previous();
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: iconcolor,
                                  size: 20,
                                ),
                              ),
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: tilecolor),
                                child: IconButton(
                                  icon: Icon(
                                    (isPlaying)
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: iconcolor,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    await audioPlayer.playOrPause();

                                    // playsong(value);
                                    setState(() {
                                      isPlaying = !isPlaying;
                                    });
                                  },
                                )),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: tilecolor),
                              child: IconButton(
                                onPressed: () async {
                                  await audioPlayer.next();
                                  // rsongs = RecentlyPlayed(
                                  //     id: songs.id,
                                  //     artist: songs.artist,
                                  //     duration: songs.duration,
                                  //     songname: songs.songname,
                                  //     songurl: songs.songurl);

                                  // updateRecentlyPlayed(rsongs);
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: iconcolor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
