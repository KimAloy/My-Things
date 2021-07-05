import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mythings/pages/drafts.dart';
import 'package:mythings/repositories/auth_service.dart';
import 'package:mythings/widgets/get_user_name.dart';
import 'package:mythings/widgets/my_dialog.dart';

import '../repositories/utils.dart';
import 'draft_length_widget.dart';

class MyDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _auth = AuthenticationService();
    final draftProvider = watch(draftsStreamProvider);

    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 65,
            child: DrawerHeader(child: GetUserName()), //user name
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file_outlined),
            title: draftProvider.when(
                data: (val) => Row(
                      children: [
                        Text('Drafts'),
                        const SizedBox(width: 4),
                        DraftLengthWidget(),
                      ],
                    ),
                loading: () => Text('Drafts'),
                error: (error, stack) => Text('Oops!')),
            // title: Text('Drafts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DraftsPage();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign out'),
            onTap: _auth.signOut,
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete account'),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MyDialog(
                      title: 'Do you want to permanently delete your account?',
                      onPressed: () async {
                        Navigator.pop(context);
                        await _auth.deleteAccount();
                        Utils.showSnackBar(
                            context, 'Account deleted successfully');
                      },
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
