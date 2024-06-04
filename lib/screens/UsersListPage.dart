import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:location_app/FriendsList.dart';
import 'package:location_app/controllers/Controller.dart';
import 'package:location_app/CustomUser.dart';


class UsersListPage extends StatefulWidget{
  const UsersListPage({super.key});

  @override
  State<StatefulWidget> createState() => _UsersListPage();

}


class _UsersListPage extends State<UsersListPage>{

  List<CustomUser> users = [];
  List<FriendsList> friends = [];
  bool isLoading = true;


  @override
  void initState() {

     getAllUsers().then((value) {
       for (int i = 0; i < value!.documents.length; i++) {

         Map<String, dynamic>? map = value.documents[i].data;
         CustomUser user = CustomUser.fromMap(map);

         getUser().then((onValue){
           setState(() {
             getDocumentId(onValue!.name).then((onValue){
               getFriendsList().then((value) {
                 for (int i = 0; i < value!.documents.length; i++) {

                   Map<String, dynamic>? map = value.documents[i].data;
                   FriendsList list = FriendsList.fromMap(map);
                   log("${list.arrayOfFriendsId}", name: "IDs");
                   setState(() {
                     friends.add(list);
                   });
                 }

                 setState(() {
                   if(user.id != onValue && !friends.any((friendList) => friendList.arrayOfFriendsId.contains(user.id))){
                     users.add(user);
                   }
                 });
               });
             });

           });
         });
       }


      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Все пользователи")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(users[index].name, style: const TextStyle(fontSize: 20)),
                    trailing: ElevatedButton(
                      onPressed: () {
                        List<FriendsList> friends = [];

                        getFriendsList().then((value) {
                          for (int i = 0; i < value!.documents.length; i++) {
                            setState(() {
                              Map<String, dynamic>? map =
                                  value.documents[i].data;
                              log(map.toString(), name: "map_values");
                              FriendsList list = FriendsList.fromMap(map);
                              friends.add(list);
                            });
                          }

                          setState(() {
                            var addingUserId = users[index].id;
                            friends.first.arrayOfFriendsId.add(addingUserId);
                            updateFriendsList(friends.first);
                            users.removeAt(index);
                          });
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                            "Пользователь добавлен в друзья",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green.shade400,
                        ));
                      },
                      child: const Text("Добавить"),
                    ),
                  ),
                );
              }),
    );
  }
}