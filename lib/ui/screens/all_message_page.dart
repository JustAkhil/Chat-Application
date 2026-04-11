import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_routes/app_routes.dart';

class AllMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("All Messages", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    onTap: ()async{
                      SharedPreferences prefs=await SharedPreferences.getInstance();
                      prefs.setString(FirebaseRepository.PREFS_USER_ID_KEY,"");
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text("Logout"))
              ];
            },
            child: Icon(Icons.more_vert_sharp),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
        Navigator.pushNamed(context, AppRoutes.allContactsPage);
      }),
    );
  }
}
