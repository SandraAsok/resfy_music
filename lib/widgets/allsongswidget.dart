import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/bloc_logic/allsongs/allsongs_bloc.dart';
import 'package:resfy_music/bloc_logic/favourites/favourites_bloc.dart';
import 'package:resfy_music/bloc_logic/mostplayed/mostplayed_bloc.dart';
import 'package:resfy_music/bloc_logic/recentlyplayed/recentlyplayed_bloc.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/favourites.dart';
import 'package:resfy_music/db/models/mostplayed.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/db/models/recentlyplayed.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/screens/nowplayingscreen.dart';
import 'package:resfy_music/widgets/addtofavourites.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';

// ignore: must_be_immutable
class AllSongsWidget extends StatelessWidget {
  AllSongsWidget({super.key});

  bool istaped = true;

  bool isalready = true;

  final box = SongBox.getInstance();

  final box4 = Favouritesbox.getinstance();

  List<Audio> convertaudio = [];

  List<MostPlayed> mostplayedsong = mostbox.values.toList();

  //  List<Songs> dbsongs = box.values.toList();
  @override
  Widget build(BuildContext context) {
    double vheight = MediaQuery.of(context).size.height;
    List<Songs> dbsongs = box.values.toList();

    for (var item in dbsongs) {
      convertaudio.add(Audio.file(item.songurl!,
          metas: Metas(title: item.songname, id: item.id.toString())));
    }
    return Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        children: [
          BlocBuilder<AllsongsBloc, AllsongsState>(
            builder: ((context, state) {
              if (state is AllsongsInitial) {
                context.read<AllsongsBloc>().add(FetchAllSongs());
              }
              if (state is DisplayAllSongs) {
                return state.Allsongs.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.Allsongs.length,
                          itemBuilder: ((context, index) {
                            RecentlyPlayed rsongs;
                            Songs songs = state.Allsongs[index];
                            MostPlayed mostsong = mostplayedsong[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 5, bottom: 10),
                              child: ListTile(
                                onTap: () {
                                  audioPlayer.open(
                                    Playlist(
                                        audios: convertaudio,
                                        startIndex: index),
                                    headPhoneStrategy: HeadPhoneStrategy
                                        .pauseOnUnplugPlayOnPlug,
                                    showNotification: true,
                                  );
                                  NowPlayingScreen.nowplayingindex.value;
                                  NowPlayingSlider.enteredvalue.value;
                                  rsongs = RecentlyPlayed(
                                    id: state.Allsongs[index].id,
                                    index: index,
                                    duration: state.Allsongs[index].duration,
                                    songname: state.Allsongs[index].songname,
                                    songurl: state.Allsongs[index].songurl,
                                  );
                                  BlocProvider.of<RecentlyplayedBloc>(context)
                                      .add(AddToRecentlyPlayed(rsongs));
                                  context.read<MostplayedBloc>().add(
                                      UpdateMostPlayedCount(mostsong, index));
                                },
                                leading: QueryArtworkWidget(
                                  artworkHeight: vheight * 0.06,
                                  artworkWidth: vheight * 0.06,
                                  keepOldArtwork: true,
                                  artworkBorder: BorderRadius.circular(10),
                                  id: state.Allsongs[index].id!,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      height: vheight * 0.06,
                                      width: vheight * 0.06,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  state.Allsongs[index].songname!,
                                  style: const TextStyle(color: fontcolor),
                                ),
                                trailing: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    IconButton(onPressed: () {
                                      BlocProvider.of<FavouritesBloc>(context)
                                          .add(AddorRemoveFavourites(
                                              Favourites(
                                                songname: state
                                                    .Allsongs[index].songname,
                                                duration: state
                                                    .Allsongs[index].duration,
                                                songurl: state
                                                    .Allsongs[index].songurl,
                                                id: state.Allsongs[index].id,
                                              ),
                                              index));
                                    }, icon: BlocBuilder<FavouritesBloc,
                                        FavouritesState>(
                                      builder: (context, state) {
                                        return Icon(
                                          Icons.favorite,
                                          color: (checkFavoriteStatus(
                                                  index, BuildContext))
                                              ? tilecolor
                                              : iconcolor,
                                        );
                                      },
                                    )),
                                    IconButton(
                                      onPressed: () {
                                        showplaylistoptions(context, index);
                                      },
                                      icon: const Icon(Icons.playlist_add),
                                      color: iconcolor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    : Text('data');
              }
              return Text('data');
            }),
          ),
          // Container(
          //   height: vheight * 0.7,
          //   color: bgcolor,
          //   child: ValueListenableBuilder<Box<Songs>>(
          //     valueListenable: box.listenable(),
          //     builder: ((context, Box<Songs> allsongbox, child) {
          //       List<Songs> alldbsongs = allsongbox.values.toList();
          //       return ListView.builder(
          //           // physics: const NeverScrollableScrollPhysics(),
          //           shrinkWrap: true,
          //           itemCount: alldbsongs.length,
          //           itemBuilder: ((context, index) {
          //             RecentlyPlayed rsongs;
          //             Songs songs = alldbsongs[index];
          //             return Padding(
          //               padding: const EdgeInsets.only(
          //                   top: 15, left: 5, bottom: 10.0),
          //               child: ListTile(
          //                 onTap: () {
          //                   player.open(
          //                     Playlist(audios: convertaudio, startIndex: index),
          //                     headPhoneStrategy:
          //                         HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
          //                     showNotification: true,
          //                     autoStart: true,
          //                   );
          //                   NowPlayingScreen.nowplayingindex.value = index;
          //                   NowPlayingSlider.enteredvalue.value = index;

          //                   //setState(() {});
          //                   rsongs = RecentlyPlayed(
          //                       id: songs.id,
          //                       duration: songs.duration,
          //                       songname: songs.songname,
          //                       songurl: songs.songurl,
          //                       index: index);

          //                   updaterecentlyplayed(rsongs);
          //                   Navigator.of(context).push(MaterialPageRoute(
          //                       builder: ((context) => NowPlayingScreen())));
          //                 },
          //                 leading: QueryArtworkWidget(
          //                   id: alldbsongs[index].id!,
          //                   type: ArtworkType.AUDIO,
          //                   keepOldArtwork: true,
          //                   artworkBorder: BorderRadius.circular(10),
          //                   nullArtworkWidget: ClipRRect(
          //                     borderRadius: BorderRadius.circular(10),
          //                     child: Image.asset("assets/logo.png"),
          //                   ),
          //                 ),
          //                 title: Text(
          //                   alldbsongs[index].songname!,
          //                   style: const TextStyle(color: fontcolor),
          //                 ),
          //                 trailing: Wrap(
          //                   crossAxisAlignment: WrapCrossAlignment.center,
          //                   children: [
          //                     IconButton(
          //                         onPressed: () {
          //                           showOptions(context, index);
          //                         },
          //                         icon: const Icon(
          //                           Icons.more_vert,
          //                           color: iconcolor,
          //                         ))
          //                   ],
          //                 ),
          //               ),
          //             );
          //           }));
          //     }),
          //   ),
          // ),
          const NowPlayingSlider(),
        ],
      ),
      // bottomSheet: const NowPlayingSlider(),
    );
  }
}

//final OnAudioQuery audioQuery = OnAudioQuery();

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
final mostbox = MostplayedBox.getInstance();

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
