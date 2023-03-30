import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resfy_music/widgets/addToFavourites.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Liked extends StatefulWidget {
  const Liked({super.key});

  @override
  State<Liked> createState() => _LikedState();
}

final player = AssetsAudioPlayer.withId('0');

class _LikedState extends State<Liked> {
  final List<Favourites> favourite = [];
  final box = Favouritesbox.getinstance();
  late List<Favourites> favouritesongs2 = box.values.toList();
  bool isalready = true;
  bool isplaying = false;
  List<Audio> favsong = [];

  @override
  void initState() {
    // TODO: implement initState
    final List<Favourites> favouritesongs =
        box.values.toList().reversed.toList();
    for (var item in favouritesongs) {
      favsong.add(
        Audio.file(
          item.songurl.toString(),
          metas: Metas(
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    'Liked Songs',
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
                                  Playlist(audios: favsong, startIndex: 0),
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
                    }),
                  ),
                ),
                ValueListenableBuilder<Box<Favourites>>(
                  valueListenable: box.listenable(),
                  builder: (context, Box<Favourites> favouriteDB, child) {
                    List<Favourites> favouritesongs =
                        favouriteDB.values.toList().reversed.toList();
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: favouritesongs.length,
                      itemBuilder: ((context, index) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 5),
                            child: ListTile(
                                onTap: () {
                                  player.open(
                                      Playlist(
                                          audios: favsong, startIndex: index),
                                      showNotification: true,
                                      headPhoneStrategy:
                                          HeadPhoneStrategy.pauseOnUnplug,
                                      loopMode: LoopMode.playlist);
                                },
                                leading: QueryArtworkWidget(
                                  keepOldArtwork: true,
                                  artworkBorder: BorderRadius.circular(10),
                                  id: favouritesongs[index].id!,
                                  type: ArtworkType.AUDIO,
                                ),
                                title: Text(
                                  favouritesongs[index].songname!,
                                  style: const TextStyle(color: fontcolor),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      // deletefavourite(index);
                                      showfavoriteremove(context, index);
                                    },
                                    icon: const Icon(Icons.favorite),
                                    color: Colors.white)),
                          )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showOptions(BuildContext context, int index) {
    double vwidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            backgroundColor: bgcolor,
            alignment: Alignment.bottomCenter,
            content: SizedBox(
              height: 250,
              width: vwidth,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          deletefavourite(index);
                          setState(
                            () {
                              isalready = !isalready;
                            },
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: iconcolor,
                        ),
                        label: const Text(
                          'Remove from Favourites',
                          style: TextStyle(color: fontcolor, fontSize: 17),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.playlist_add,
                          color: iconcolor,
                        ),
                        label: const Text(
                          'Add to Playlist',
                          style: TextStyle(color: fontcolor, fontSize: 17),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: iconcolor,
                        ),
                        label: const Text(
                          'Share',
                          style: TextStyle(color: fontcolor, fontSize: 17),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.shuffle,
                          color: fontcolor,
                        ),
                        label: const Text(
                          'Shuffle',
                          style: TextStyle(color: fontcolor, fontSize: 17),
                        )),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.repeat,
                        color: fontcolor,
                      ),
                      label: const Text(
                        'Repeat',
                        style: TextStyle(color: fontcolor, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

showfavoriteremove(BuildContext context, int index) {
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            backgroundColor: bgcolor,
            alignment: Alignment.bottomCenter,
            content: Container(
              height: 150,
              width: vwidth,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Are you sure?',
                            style: TextStyle(color: fontcolor, fontSize: 25),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: iconcolor,
                              ),
                              label: Text(
                                'cancel',
                                style:
                                    TextStyle(color: fontcolor, fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: vwidth * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: tilecolor,
                              ),
                              child: TextButton.icon(
                                onPressed: () {
                                  deletefavourite(index);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: iconcolor,
                                ),
                                label: Text(
                                  'Yes',
                                  style:
                                      TextStyle(color: fontcolor, fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )));
}
