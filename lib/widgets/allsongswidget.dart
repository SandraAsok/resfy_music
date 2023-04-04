import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/functions/dbfunctions.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:resfy_music/db/models/mostplayed.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/db/models/recentlyplayed.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/screens/nowplayingscreen.dart';
import 'package:resfy_music/widgets/addtofavourites.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';

class AllSongsWidget extends StatefulWidget {
  AllSongsWidget({super.key});

  @override
  State<AllSongsWidget> createState() => _AllSongsWidgetState();
}

//final OnAudioQuery audioQuery = OnAudioQuery();

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
final mostbox = MostplayedBox.getInstance();

class _AllSongsWidgetState extends State<AllSongsWidget> {
  bool istaped = true;
  bool isalready = true;
  final box = SongBox.getInstance();
  final box4 = Favouritesbox.getinstance();

  List<Audio> convertaudio = [];
  List<MostPlayed> mostplayed = mostbox.values.toList();
  // List<Audio> convertAudios = [];

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
    return Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Container(
            height: 550,
            color: bgcolor,
            child: ValueListenableBuilder<Box<Songs>>(
              valueListenable: box.listenable(),
              builder: ((context, Box<Songs> allsongbox, child) {
                List<Songs> alldbsongs = allsongbox.values.toList();
                return Expanded(
                  child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: alldbsongs.length,
                      itemBuilder: ((context, index) {
                        RecentlyPlayed rsongs;
                        Songs songs = alldbsongs[index];
                        MostPlayed mostsong = mostplayed[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 5, bottom: 10.0),
                          child: ListTile(
                            onTap: () {
                              player.open(
                                Playlist(
                                    audios: convertaudio, startIndex: index),
                                headPhoneStrategy:
                                    HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                                showNotification: true,
                                autoStart: true,
                              );
                              NowPlayingScreen.nowplayingindex.value = index;
                              NowPlayingSlider.enteredvalue.value = index;

                              //setState(() {});
                              rsongs = RecentlyPlayed(
                                  id: songs.id,
                                  duration: songs.duration,
                                  songname: songs.songname,
                                  songurl: songs.songurl,
                                  index: index);

                              updaterecentlyplayed(rsongs);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => NowPlayingScreen())));
                            },
                            leading: QueryArtworkWidget(
                              id: alldbsongs[index].id!,
                              type: ArtworkType.AUDIO,
                              keepOldArtwork: true,
                              artworkBorder: BorderRadius.circular(10),
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/logo.png"),
                              ),
                            ),
                            title: Text(
                              alldbsongs[index].songname!,
                              style: const TextStyle(color: fontcolor),
                            ),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showOptions(context, index);
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: iconcolor,
                                    ))
                              ],
                            ),
                          ),
                        );
                      })),
                );
              }),
            ),
          ),
          const NowPlayingSlider(),
        ],
      ),
      // bottomSheet: const NowPlayingSlider(),
    );
  }
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
            height: 150,
            width: vwidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        if (checkFavoriteStatus(index, BuildContext)) {
                          addToFavourites(index);
                        } else if (!checkFavoriteStatus(index, BuildContext)) {
                          removefavourite(index);
                        }
                        setState(() {});

                        Navigator.pop(context);
                      },
                      icon: (checkFavoriteStatus(index, context))
                          ? const Icon(
                              Icons.favorite_border_outlined,
                              color: iconcolor,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: iconcolor,
                            ),
                      label: (checkFavoriteStatus(index, context))
                          ? const Text(
                              'Add to Favourites',
                              style: TextStyle(color: fontcolor, fontSize: 17),
                            )
                          : const Text(
                              'Remove from Favourites',
                              style: TextStyle(color: fontcolor, fontSize: 17),
                            )),
                  TextButton.icon(
                      onPressed: () {
                        showplaylistoptions(context, index);
                      },
                      icon: const Icon(
                        Icons.playlist_add,
                        color: iconcolor,
                      ),
                      label: const Text(
                        'Add to Playlist',
                        style: TextStyle(color: fontcolor, fontSize: 17),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

showplaylistoptions(BuildContext context, int index) {
  final box = PlaylistSongsbox.getInstance();
  showDialog(
      context: context,
      builder: ((context) => StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: tilecolor,
                alignment: Alignment.bottomCenter,
                content: SizedBox(
                  height: 300,
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<Box<PlaylistSongs>>(
                            valueListenable: box.listenable(),
                            builder: ((context,
                                Box<PlaylistSongs> playlistsongs, child) {
                              List<PlaylistSongs> playlistsong =
                                  playlistsongs.values.toList();
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: playlistsong.length,
                                itemBuilder: ((context, index) {
                                  return ListTile(
                                    onTap: () {
                                      PlaylistSongs? playsong =
                                          playlistsongs.getAt(index);
                                      List<Songs> playsongdb =
                                          playsong!.playlistssongs!;
                                      final songbox = SongBox.getInstance();
                                      List<Songs> songdb =
                                          songbox.values.toList();
                                      bool isalreadyadded = playsongdb.any(
                                          (element) =>
                                              element.id == songdb[index].id);
                                      if (!isalreadyadded) {
                                        playsongdb.add(Songs(
                                          songname: songdb[index].songname,
                                          duration: songdb[index].duration,
                                          id: songdb[index].id,
                                          songurl: songdb[index].songurl,
                                        ));
                                      }
                                      playlistsongs.putAt(
                                          index,
                                          PlaylistSongs(
                                            playlistname: playlistsong[index]
                                                .playlistname,
                                            playlistssongs: playsongdb,
                                          ));

                                      Navigator.pop(context);
                                    },
                                    title: Text(
                                      playlistsong[index].playlistname!,
                                      style: const TextStyle(color: fontcolor),
                                    ),
                                  );
                                }),
                              );
                            })),
                      )
                    ],
                  ),
                ));
          }))));
}
