import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/widgets/createplaylist.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resfy_music/widgets/playlistfull_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final playlistbox = PlaylistSongsbox.getInstance();
  late List<PlaylistSongs> playlistsong = playlistbox.values.toList();

  @override
  Widget build(BuildContext context) {
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
              ValueListenableBuilder<Box<PlaylistSongs>>(
                valueListenable: playlistbox.listenable(),
                builder: (context, Box<PlaylistSongs> playlistsongs, child) {
                  List<PlaylistSongs> playlistsong =
                      playlistsongs.values.toList();
                  return playlistsong.isNotEmpty
                      ? (ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlistsong.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => PlaylistFullList(
                                            playindex: index,
                                            playlistname: playlistsong[index]
                                                .playlistname))));
                              },
                              leading: playlistsong[index]
                                      .playlistssongs!
                                      .isNotEmpty
                                  ? QueryArtworkWidget(
                                      keepOldArtwork: true,
                                      artworkBorder: BorderRadius.circular(10),
                                      id: playlistsong[index]
                                          .playlistssongs![0]
                                          .id!,
                                      type: ArtworkType.AUDIO)
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
                                playlistsong[index].playlistname!,
                                style: const TextStyle(color: fontcolor),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showPlaylistEditOption(context, index);
                                    },
                                    icon: const Icon(Icons.edit),
                                    color: iconcolor,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showplaylistdeleteoptions(context, index);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: iconcolor,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ))
                      : const Center(
                          child: Text(
                            "You haven't created any playlist!",
                            style: TextStyle(color: fontcolor),
                          ),
                        );
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
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          myController.clear();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 100.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 20,
                              color: fontcolor,
                            ),
                          ),
                        ),
                      ),
                      ValueListenableBuilder<TextEditingValue>(
                          valueListenable: myController,
                          builder: ((context, controller, child) {
                            return TextButton(
                              onPressed: myController.text.isEmpty
                                  ? null
                                  : !checkIfAlreadyExists(myController.text)
                                      ? () async {
                                          createplaylist(myController.text);
                                          Navigator.pop(context);
                                          myController.clear();
                                        }
                                      : () async {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  backgroundColor: tilecolor,
                                                  content: Text(
                                                    "Playlist Already exists !!!",
                                                    style: TextStyle(
                                                        color: fontcolor),
                                                  )));
                                        },
                              child: const Text(
                                'Done',
                                style:
                                    TextStyle(fontSize: 20, color: fontcolor),
                              ),
                            );
                          }))
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
                                  deletePlaylist(index);
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
                          editPlaylist(textEditmyController.text, index);
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
