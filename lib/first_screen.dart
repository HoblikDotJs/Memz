import 'package:flutter/material.dart';
import 'package:memz/login_page.dart';
import 'pages/new_page.dart';
import 'pages/favourite_page.dart';

TabController tabController;

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          children: [FavouritesPage(), NewPage()],
        ),
      ),
    );
  }
}
