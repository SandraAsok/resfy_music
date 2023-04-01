import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/db/models/songmodel.dart';

// ignore: must_be_immutable
class PlaylistFullList extends StatefulWidget {
  PlaylistFullList(
      {super.key, required this.playindex, required this.playlistname});

  int? playindex;
  String? playlistname;

  @override
  State<PlaylistFullList> createState() => _PlaylistFullListState();
}

class _PlaylistFullListState extends State<PlaylistFullList> {
  final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
  List<Audio> convertaudio = [];

  @override
  void initState() {
    final playbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsong = playbox.values.toList();
    for (var item in playlistsong[widget.playindex!].playlistssongs!) {
      convertaudio.add(Audio.file(item.songurl!,
          metas: Metas(
            title: item.songname,
            id: item.id.toString(),
          )));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsong = playbox.values.toList();
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 40,
                      height: 40,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: iconcolor,
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  playlistsong[widget.playindex!].playlistname!,
                  style: const TextStyle(fontSize: 20, color: fontcolor),
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
                                Playlist(audios: convertaudio, startIndex: 0),
                                showNotification: true);
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
              ValueListenableBuilder(
                  valueListenable: playbox.listenable(),
                  builder: ((context, Box<PlaylistSongs> playlistsongs, child) {
                    List<PlaylistSongs> playlistsong =
                        playlistsongs.values.toList();
                    List<Songs>? playsong =
                        playlistsong[widget.playindex!].playlistssongs;
                    return playsong!.isNotEmpty
                        ? (ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: playsong.length,
                            itemBuilder: ((context, index) => ListTile(
                                  title: Text(
                                    playsong[index].songname!,
                                    style: const TextStyle(color: fontcolor),
                                  ),
                                  trailing: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              playsong.removeAt(index);
                                              playlistsong
                                                  .removeAt(widget.playindex!);
                                              playbox.putAt(
                                                  widget.playindex!,
                                                  PlaylistSongs(
                                                      playlistname:
                                                          widget.playlistname!,
                                                      playlistssongs:
                                                          playsong));
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: iconcolor,
                                            size: 25,
                                          )),
                                    ],
                                  ),
                                  onTap: () {
                                    player.open(
                                        Playlist(
                                            audios: convertaudio,
                                            startIndex: index),
                                        showNotification: true);
                                  },
                                )),
                          ))
                        : const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: Text(
                                'Please add a song!',
                                style: TextStyle(color: fontcolor),
                              ),
                            ),
                          );
                  }))
            ],
          ),
        ),
      )),
    );
  }
}
