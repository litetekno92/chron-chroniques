import 'package:flutter/material.dart';
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
 // CustomAppBar({Key key}) : super(key: key);
  static final CustomAppBar _appbar = new CustomAppBar._internal();

  factory CustomAppBar({Key key}) {
   //uper(key: key);
    return _appbar;
  }

  CustomAppBar._internal();

  CustomAppBarState createState() => CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 40.0);
}

class CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 5);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
       title: Text('LiteTekno '),
       bottom: TabBar(
         tabs: <Widget>[
           new Tab(
                    text: "STATISTICS",
        //            key.currentState.
             //       icon: new Icon(Icons.show_chart),
                  ),
              //     new Tab(
              //       text: "HISTORY",
              // //      icon: new Icon(Icons.history),
              //     ),
                ],
                controller: _tabController,
       )
       );
  }
}