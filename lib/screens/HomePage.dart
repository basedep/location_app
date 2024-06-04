import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location_app/FriendsList.dart';
import 'package:location_app/controllers/Controller.dart';
import 'package:location_app/screens/Map.dart';

import 'FriendsListScreen.dart';
import 'UsersListPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? _currentUser;
  bool isLoading = true;

  @override
  void initState() {
    getUser().then((value) {
      setState(() {
        _currentUser = value!;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                    MapPage(),
                    FriendsListPage(),
                    UsersListPage()
                  ]),
        appBar: AppBar(
          title: Text("Привет ${_currentUser?.name} 👋"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: "Карта" ),
              Tab(icon: Icon(Icons.person), text: "Друзья"),
              Tab(icon: Icon(Icons.person_pin_sharp), text: "Пользователи"),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  logoutUser();
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Text("Выйти"))
          ],
        ),
      ),
    );
  }
}