import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllContactPage extends StatelessWidget {
  FirebaseRepository firebaseRepository=FirebaseRepository.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Contacts", style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firebaseRepository.getAllContacts(),
        builder: (_, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if(snapshots.hasError){
            return Center(child: Text(snapshots.error.toString()),);
          }else if(snapshots.hasData){
            return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (_,index){
                  UserModel currModel=UserModel.fromDoc(snapshots.data!.docs[index].data());
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(currModel.name!),
                      subtitle: Text(currModel.email!),
                    ),
                  ),
                ),
              );
            });
          }
          return Container();
        },
      ),
    );
  }
}
