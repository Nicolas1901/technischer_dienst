import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/admin/presentation/user_details.dart';
import 'package:technischer_dienst/features/templates/presentation/show_templates.dart';
import 'package:technischer_dienst/shared/presentation/components/td_circle_avatar.dart';

import '../../../Constants/asset_images.dart';
import '../../../enums/roles.dart';
import '../../../features/admin/presentation/user_list.dart';
import '../../../features/authentication/application/AuthBloc/auth_bloc.dart';
import '../../../features/authentication/domain/Appuser.dart';
import '../../../features/authentication/presentation/login.dart';
import '../../../features/reports/presentation/report_list.dart';

class TdNavigationDrawer extends StatelessWidget {
  const TdNavigationDrawer({
    super.key,
    this.onLogout,
    required this.selectedIndex,
    required this.currentUser,
  });

  final AppUser? currentUser;
  final int selectedIndex;
  final Function? onLogout;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Theme.of(context).focusColor;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(currentUser?.username ?? ""),
            accountEmail: Text(currentUser?.email ?? ""),
            currentAccountPicture:
                TdCircleAvatar(url: currentUser?.profileImage ?? ""),
            onDetailsPressed: () {
              if (currentUser != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UserDetails(user: currentUser!)));
              }
            },
          ),
          ListTile(
              tileColor: selectedIndex == 0 ? activeColor : null,
              title: const Text("Vorlagen"),
              leading: const Icon(Icons.fire_truck),
              onTap: () {
                if (selectedIndex != 0) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const ShowTemplates(title: "Vorlagen")));
                }
              }),
          ListTile(
              tileColor: selectedIndex == 1 ? activeColor : null,
              title: const Text("Berichte"),
              leading: const Icon(Icons.file_copy),
              onTap: () {
                if (selectedIndex != 1) {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportList()));
                }
              }),
          if (currentUser != null && currentUser?.role == Role.admin.value)
            ListTile(
                tileColor: selectedIndex == 2 ? activeColor : null,
                title: const Text("Benutzerverwaltung"),
                leading: const Icon(Icons.group),
                onTap: () {
                  if (selectedIndex != 2) {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UserList()));
                  }
                }),
          ListTile(
              tileColor: selectedIndex == -1 ? activeColor : null,
              title: const Text("Abmelden"),
              leading: const Icon(Icons.logout),
              onTap: () {
                if (selectedIndex != -1) {
                  context.read<AuthBloc>().add(Logout());
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
                }
              }),
        ],
      ),
    );
  }
}
