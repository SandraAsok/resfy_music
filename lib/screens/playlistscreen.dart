import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resfy_music/bloc_logic/playlist/playlist_bloc.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/widgets/createplaylist.dart';
import 'package:resfy_music/widgets/playlistfull_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListScreen extends StatelessWidget {
  PlayListScreen({super.key});

  final playlistbox = PlaylistSongsbox.getInstance();

  late List<PlaylistSongs> playlistsong = playlistbox.values.toList();

  @override
  Widget build(BuildContext context) {
    double vheight = MediaQuery.of(context).size.height;
    return SafeArea(
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
                  'Your Playlists',
                  style: TextStyle(fontSize: 20, color: fontcolor),
                ),
                trailing: Wrap(
                  spacing: 10,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: tilecolor),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: iconcolor,
                        iconSize: 30,
                        onPressed: () {
                          showplaylistaddoptions(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
                  if (state is PlaylistInitial) {
                    context.read<PlaylistBloc>().add(FetchPlaylistSongs());
                  }
                  if (state is DisplayPlaylist) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.Playlist.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => PlaylistFullList(
                                            playindex: index,
                                            playlistname: state
                                                .Playlist[index].playlistname,
                                          ))));
                            },
                            leading: state
                                    .Playlist[index].playlistssongs!.isNotEmpty
                                ? QueryArtworkWidget(
                                    keepOldArtwork: true,
                                    artworkBorder: BorderRadius.circular(10),
                                    id: state
                                        .Playlist[index].playlistssongs![0].id!,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        height: vheight * 0.06,
                                        width: vheight * 0.06,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            title: Text(
                              state.Playlist[index].playlistname!,
                              style: TextStyle(color: fontcolor),
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showPlaylistEditOption(context, index);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: iconcolor,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    showplaylistdeleteoptions(context, index);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: iconcolor,
                                  ),
                                )
                              ],
                            ),
                          );
                        }));
                  }
                  return Text("Your Playlists");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

showplaylistaddoptions(BuildContext context) {
  final myController = TextEditingController();
  double vwidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: const EdgeInsets.only(bottom: 100.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: tilecolor,
      alignment: Alignment.bottomCenter,
      content: SizedBox(
        height: 250,
        width: vwidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Create Playlist',
                    style: TextStyle(fontSize: 25, color: fontcolor),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: vwidth * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          style: const TextStyle(color: fontcolor),
                          controller: myController,
                          decoration: const InputDecoration(
                            fillColor: tilecolor,
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: iconcolor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20, color: fontcolor),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.done,
                          color: iconcolor,
                        ),
                        onPressed: () {
                          context
                              .read<PlaylistBloc>()
                              .add(CreatePlaylist(myController.text));
                          Navigator.pop(context);
                        },
                        label: Text(
                          'Done',
                          style: TextStyle(fontSize: 20, color: fontcolor),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

showplaylistdeleteoptions(BuildContext context, int index) {
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
            content: SizedBox(
              height: 150,
              width: vwidth,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
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
                              label: const Text(
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
                                  context
                                      .read<PlaylistBloc>()
                                      .add(DeletePlaylist(index));
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: iconcolor,
                                ),
                                label: const Text(
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

showPlaylistEditOption(BuildContext context, int index) {
  final playlistbox = PlaylistSongsbox.getInstance();
  List<PlaylistSongs> playlistsong = playlistbox.values.toList();
  final textEditmyController =
      TextEditingController(text: playlistsong[index].playlistname);
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Edit Playlist',
                    style: TextStyle(fontSize: 25, color: fontcolor),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: vwidth * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: tilecolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 5, bottom: 5),
                        child: TextFormField(
                          style: const TextStyle(color: fontcolor),
                          controller: textEditmyController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            fillColor: tilecolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: tilecolor,
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: iconcolor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20, color: fontcolor),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: tilecolor,
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.done,
                          color: iconcolor,
                        ),
                        onPressed: () {
                          context.read<PlaylistBloc>().add(
                              EditPlaylist(index, textEditmyController.text));
                          Navigator.pop(context);
                        },
                        label: const Text(
                          'Done',
                          style: TextStyle(fontSize: 20, color: fontcolor),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
