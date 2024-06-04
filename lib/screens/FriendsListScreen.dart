import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:location_app/FriendsList.dart';
import 'package:location_app/controllers/Controller.dart';
import 'package:location_app/CustomUser.dart';


class FriendsListPage extends StatefulWidget{
  const FriendsListPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsListPage();

}


class _FriendsListPage extends State<FriendsListPage>{

  List<CustomUser> users = [];

  bool isLoading = true;


  @override
  void initState() {

    getFriendsList().then((value) {
      for (int i = 0; i < value!.documents.length; i++) {

          Map<String, dynamic>? map = value.documents[i].data;
          FriendsList list = FriendsList.fromMap(map);

          for (int j = 0; j < list.arrayOfFriendsId.length; j++) {
            getAddedFriend(list.arrayOfFriendsId).then((onValue){

                  Map<String, dynamic>? map = onValue!.documents[j].data;
                  CustomUser user = CustomUser.fromMap(map);
                  setState(() {
                  users.add(user);
                });
            });
          }
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
      appBar: AppBar(title: const Text("Мои друзья")),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          :ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 3,
              child: ListTile(title: Text(users[index].name, style: const TextStyle(fontSize: 20)),
                trailing: ElevatedButton(
                  onPressed: () {

                    List<FriendsList> friends = [];

                    getFriendsList().then((value) {
                      for (int i = 0; i < value!.documents.length; i++) {
                        setState(() {
                          Map<String, dynamic>? map = value.documents[i].data;
                          FriendsList list = FriendsList.fromMap(map);
                          friends.add(list);
                        });
                      }

                      setState(() {
                        var deleteUserId = users[index].id;
                        friends.first.arrayOfFriendsId.remove(deleteUserId);
                        updateFriendsList(friends.first);

                        users.removeAt(index);
                      });
                    });



                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:const  Text(
                        "Пользователь удален из друзей",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green.shade400,
                    ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Удалить", style: TextStyle(color: Colors.white)),),
              ),
            );
          }),
    );
  }

}