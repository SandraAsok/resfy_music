import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';

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
              'assets/images/logo.png',
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: iconcolor,
                size: 25,
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: fontcolor, fontSize: 20),
              ),
              onTap: () {},
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
              onTap: () {},
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
