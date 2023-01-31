import 'package:flutter/material.dart';

import '../models/user.dart';

class UserInfoPage extends StatelessWidget {

  final User userInfo;

  const UserInfoPage(this.userInfo,{super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USER INFO'),
      ),
      body: Card(
        child: Column(
          children:   [
            ListTile(
              leading: const Icon(Icons.person,color: Colors.black,),
              title: Text(userInfo.name),
              subtitle: Text(userInfo.story),
              trailing: Text(userInfo.country),
            ),
            ListTile(
              leading: const Icon(Icons.info,color: Colors.black,),
              title: Text(userInfo.phone),
              subtitle: Text(userInfo.email),
            )
          ],
        ),
      ),
    );
  }
}
