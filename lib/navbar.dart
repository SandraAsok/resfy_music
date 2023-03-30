import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/widgets/popup.dart';
import 'package:share_plus/share_plus.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgcolor,
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 250,
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: iconcolor,
                size: 25,
              ),
              title: const Text(
                'About',
                style: TextStyle(color: fontcolor, fontSize: 20),
              ),
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationName: "Resfy Player.",
                    applicationIcon: Image.asset(
                      "assets/logo.png",
                      height: 32,
                      width: 32,
                    ),
                    applicationVersion: "1.0.0",
                    children: [
                      const Text(
                          "Resfy is an offline music player app which allows use to hear music from their local storage and also do functions like add to favorites , create playlists , recently played , mostly played etc."),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("App developed by Sandra Ashok.")
                    ]);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.shield,
                color: iconcolor,
                size: 25,
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: fontcolor, fontSize: 20),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return settingmenupopup(mdFilename: 'privacypolicy.md');
                    });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.perm_device_information,
                color: iconcolor,
                size: 25,
              ),
              title: const Text(
                'Terms and Conditions',
                style: TextStyle(color: fontcolor, fontSize: 20),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return settingmenupopup(
                          mdFilename: 'termsandconditions.md');
                    });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.share,
                color: iconcolor,
                size: 25,
              ),
              title: const Text(
                'Share',
                style: TextStyle(color: fontcolor, fontSize: 20),
              ),
              onTap: () {
                Share.share("https://github.com/SandraAsok/resfy_music",
                    subject: "GitHub Repository of this App");
              },
            ),
          ],
        ),
      ),
    );
  }
}
