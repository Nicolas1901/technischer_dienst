import 'package:flutter/material.dart';
import 'package:technischer_dienst/features/templates/presentation/show_templates.dart';

import '../../../Constants/assest_images.dart';
import '../../../features/reports/presentation/report_list.dart';

class TdNavigationDrawer extends StatelessWidget {
  const TdNavigationDrawer(
      {super.key,
      required this.accountName,
      required this.email,
      required this.avatar,
      required this.selectedIndex});

  final String accountName;
  final String email;
  final String avatar;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(email),
            currentAccountPicture:
                CircleAvatar(foregroundImage: _renderImage(avatar)),
          ),
          ListTile(
              tileColor:
                  selectedIndex == 0 ? Theme.of(context).focusColor : null,
              title: const Text("Vorlagen"),
              leading: const Icon(Icons.file_copy),
              onTap: () {
                if ( selectedIndex != 0) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const ShowTemplates(title: "Vorlagen")));
                }
              }),
          ListTile(
              tileColor:
                  selectedIndex == 1 ? Theme.of(context).primaryColor : null,
              title: const Text("Berichte"),
              leading: const Icon(Icons.file_copy),
              onTap: () {
                if (selectedIndex != 1) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportList()));
                }
              })
        ],
      ),
    );
  }

  ImageProvider _renderImage(String profileImagePath) {
    ImageProvider profileImage;

    if (profileImagePath.isNotEmpty) {
      profileImage = NetworkImage(profileImagePath);
    } else {
      profileImage = const AssetImage(AssetImages.noImageUser);
    }

    return profileImage;
  }
}
