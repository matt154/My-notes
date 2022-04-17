import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:myapp/constants/routes.dart';
import 'package:myapp/enums/menu_action.dart';
import 'package:myapp/serices/auth/auth_service.dart';



class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Main UI"),
          actions: [
            PopupMenuButton<MenuActions>(
              onSelected: (value) async {
                switch (value) {
                  case MenuActions.logout:
                    final toLogout = await showLogOutDialog(context);
                    if (toLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    }
                    devtools.log(toLogout.toString());
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuActions>(
                    value: MenuActions.logout,
                    child: Text("Log out"),
                  ),
                ];
              },
            )
          ],
        ),
        body: const Text("Hello World"));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancle"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Log out"),
            )
          ],
        );
      }).then((value) => value ?? false);
}
