import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resfy_music/bloc_logic/recentlyplayed/recentlyplayed_bloc.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/recentlyplayed.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/screens/likedscreen.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';

class Recent extends StatelessWidget {
  Recent({super.key});

  final _audioPlayer = AssetsAudioPlayer.withId('0');

  final List<RecentlyPlayed> recentplay = [];

  final box = RecentlyPlayedBox.getInstance();

  List<Audio> rcentplay = [];

  // @override
  @override
  Widget build(BuildContext context) {
    double vheight = MediaQuery.of(context).size.height;
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
    }

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
                                color: iconcolor,
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
                BlocBuilder<RecentlyplayedBloc, RecentlyplayedState>(
                  builder: ((context, state) {
                    if (state is RecentlyplayedInitial) {
                      context
                          .read<RecentlyplayedBloc>()
                          .add(FetchRecentlyPlayed());
                    }
                    if (state is DisplayRecentlyPlayed) {
                      if (state.recentPlay.isNotEmpty) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.recentPlay.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 5),
                              child: ListTile(
                                leading: QueryArtworkWidget(
                                  keepOldArtwork: true,
                                  artworkBorder: BorderRadius.circular(10),
                                  id: state.recentPlay[index].id!,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/logo.png",
                                      height: vheight * 0.06,
                                      width: vheight * 0.06,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  state.recentPlay[index].songname!,
                                  style: const TextStyle(color: fontcolor),
                                ),
                                onTap: () {
                                  player.open(
                                    Playlist(
                                      audios: rcentplay,
                                      startIndex: index,
                                    ),
                                    showNotification: true,
                                    headPhoneStrategy:
                                        HeadPhoneStrategy.pauseOnUnplug,
                                    loopMode: LoopMode.playlist,
                                  );
                                },
                              ),
                            );
                          }),
                        );
                      } else {
                        const Center(
                          child: Text(
                            "Your Recently played songs",
                            style: TextStyle(color: fontcolor),
                          ),
                        );
                      }
                    }
                    return const Text("  ");
                  }),
                )
              ],
            ),
          ),
          bottomSheet: const NowPlayingSlider(),
        ),
      ),
    );
  }
}
