import 'package:chat_application/constants/app_routes/app_routes.dart';
import 'package:chat_application/data/remote/firebase_repository.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllContactPage extends StatefulWidget {
  String fromId="";
  @override
  State<AllContactPage> createState() => _AllContactPageState();
}

class _AllContactPageState extends State<AllContactPage> {
  FirebaseRepository firebaseRepository=FirebaseRepository.getInstance();
  @override
  void initState() {
    super.initState();
    getFromId();
  }
  getFromId()async{
    widget.fromId=await firebaseRepository.getFromId();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_outlined)),
        centerTitle: true,
        title: Text("All Contacts", style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firebaseRepository.getAllContacts(),
        builder: (_, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }if(snapshots.hasError){
            return Center(child: Text(snapshots.error.toString()),);
          }
          var listContact=List.generate(snapshots.data!.docs.length, (index){
            return UserModel.fromDoc(snapshots.data!.docs[index].data());
          });
          listContact.removeWhere((element){
            return element.userId==widget.fromId;
          });
          if(snapshots.hasData){
            return ListView.builder(
                itemCount: listContact.length,
                itemBuilder: (_,index){
                  UserModel currModel=listContact[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          Navigator.pushReplacementNamed(context,AppRoutes.chatPage,arguments: currModel);
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/ic_user.png"),
                        ),
                        title: Text(currModel.name!),
                        subtitle: Text(currModel.email!),
                      ),
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
