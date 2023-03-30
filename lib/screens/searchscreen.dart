import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/songmodel.dart';

import 'package:resfy_music/widgets/nowplayingslider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    dbsongs = box.values.toList();
    super.initState();
  }

  late List<Songs> dbsongs = [];
  List<Audio> allsongs = [];
  final TextEditingController searchcontroller = TextEditingController();

  late List<Songs> searchlist = List.from(dbsongs);
  bool istaped = true;

  final box = SongBox.getInstance();

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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 47,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: searchcolor),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    controller: searchcontroller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: 'What do you want to listen to? ',
                    ),
                    onChanged: ((value) => updateSearch(value)),
                    // onChanged: ((value) {
                    //   updateSearch(value);
                    // }),
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchlist.length,
              itemBuilder: ((context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 5),
                    child: ListTile(
                      onTap: () {
                        NowPlayingSlider.enteredvalue.value = index;
                        player.open(
                          Audio.file(searchlist[index].songurl!,
                              metas: Metas(
                                  title: searchlist[index].songname,
                                  id: searchlist[index].id.toString())),
                          showNotification: true,
                        );
                      },
                      leading: QueryArtworkWidget(
                        keepOldArtwork: true,
                        artworkBorder: BorderRadius.circular(10),
                        id: searchlist[index].id!,
                        type: ArtworkType.AUDIO,
                      ),
                      title: Text(searchlist[index].songname!,
                          style: const TextStyle(color: fontcolor)),
                    ),
                  )),
            )
          ],
        )),
      )),
    );
  }

  updateSearch(String value) {
    setState(() {
      searchlist = dbsongs
          .where((element) =>
              element.songname!.toLowerCase().contains(value.toLowerCase()))
          .toList();

      allsongs.clear();
      for (var item in searchlist) {
        allsongs.add(Audio.file(item.songurl.toString(),
            metas: Metas(title: item.songname, id: item.id.toString())));
      }
    });
  }
}
