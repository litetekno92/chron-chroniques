import 'dart:convert';

import 'package:flutter/services.dart';

import '../resources/posts_db_provider.dart';

import '../models/category_model.dart';
import '../resources/shared_preferences.dart';
import '../screens/showpost.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/carouselwithindicator.dart';

import '../widgets/card.dart';

import '../models/post_model.dart';

import '../resources/repository.dart';

import '../screens/fetchdatacat.dart';

import '../resources/color.dart';

import '../models/category_model.dart' as Category;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';
//import OneSignal
import 'package:onesignal/onesignal.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_aware/platform_aware.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_offline/flutter_offline.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
//List drawerItems = [];

List<DrawerItem> drawerItems =
    categories.map((tab) => DrawerItem(tab.title, tab.icon)).toList();
// debugPrint('Length: $drawerItems.length');
//log(drawerItems.length.to);

class CustomDrawer extends StatefulWidget {
  //   new DrawerItem("Fragment 1", Icons.home),
  //   new DrawerItem("Fragment 2", Icons.info),
  //   new DrawerItem("Fragment 3", Icons.web),
  // ];
  CustomDrawer({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CustomDrawerState();
  }
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = Image.asset('images/chroniques-logo.png');
  String getSearchText() => _searchText;

  CustomSharedPreferences prefs = CustomSharedPreferences();
  bool _vNotificationsPrefs = true;
  String version = "1.190521";

  int _selectedDrawerIndex = 0;
  bool start = true;

  var drawerOptions = <Widget>[];
  TabController _tabController;
  ScrollController _scrollController = ScrollController(); // instance variable

  bool isSwitched = true;
  static const String chroniquesUrl = 'http://chroniques.sn/';
  static const String githubUrl = 'http://www.codesnippettalk.com';

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  TapGestureRecognizer _chroniquesTapRecognizer;
  TapGestureRecognizer _githubTapRecognizer;

  var allPosts = new Map();
  var posts = new List<Post>();
  var carouselPosts = new List<Post>();
  var bodyPosts = new List<Post>();
  var newPosts = new List<Post>();

  var isLoading = false;
  var displayCarousel = true;
  var displayBody = true;

  String searchText = "";
  bool _searchOnProgress = false;

  String _debugLabelString = "";
  bool _enableConsentButton = false;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = false;

  _defPosts() {
    for (var i = 0; i < categories.length; i++)
      allPosts[categories[i].title] = List<Post>();
  }

  _fetchDataCat(int category, int page) async {
    var categoryIndex = findCategoryIndexById(category);

    // C
    posts = allPosts[categories[categoryIndex].title];
    if (categories[categoryIndex].endReachedStatus) {
      setState(() {
        isLoading = false;
      });
      return null;
    }
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var nbPosts = posts.length;
      newPosts.clear();
      //ApiProvider postsApiProvider = PostsApiProvider();
      Repository repository = Repository();

      newPosts = await repository.fetchDataCat(category, page);
      // if (newPosts.isEmpty) {
      //   double edge = 50.0;
      //   double offsetFromBottom = _scrollController.position.maxScrollExtent -
      //       _scrollController.position.pixels;
      //   if (offsetFromBottom < edge) {
      //     _scrollController.animateTo(
      //         _scrollController.offset - (edge - offsetFromBottom),
      //         duration: new Duration(milliseconds: 500),
      //         curve: Curves.easeOut);
      //   }
      // }

      setState(() {
        posts.addAll(newPosts);

        //  allPosts[categories[categoryIndex].title].addAll(newPosts);
        //    posts=allPosts[categories[categoryIndex].title];
        if (nbPosts != posts.length) {
          categories[categoryIndex].currentPage =
              categories[categoryIndex].page + 1;
        } else {
          categories[categoryIndex].endReachedStatus = true;
        }

        carouselPosts.clear();
        bodyPosts.clear();
        for (var i = 0; i < posts.length; i++) {
          if ((i < 6) &&
              (posts[i].featuredMedia != 0) &&
              (posts[i].featuredMediaUrl != null)) {
            posts[i].featuredMediaUrl = posts[i].featuredMediaUrl ??
                'https://picsum.photos/250?image=9';
            carouselPosts.add(posts[i]);
            //  debugPrint("Post mediaurl :  " + posts[i].featuredMediaUrl);
          } else {
            bodyPosts.add(posts[i]);
          }
        }
        var uniqBodyPosts = bodyPosts.toSet().toList();
        bodyPosts.clear();
        bodyPosts = uniqBodyPosts;

        //  debugPrint("Posts Length :  " + posts.length.toString());
        //  debugPrint("bodyPosts Length :  " + bodyPosts.length.toString());
        // debugPrint("carouselPosts Length :  " + carouselPosts.length.toString());
        isLoading = false;
        displayCarousel = carouselPosts.length > 0;
        displayBody = bodyPosts.length > 0;
      });
    } else
      return null;
  }

  void _goFetchDataCat(int index) {
    // posts = allPosts[categories[index].id];
    // var nbPosts = posts.length;
    _fetchDataCat(categories[index].id, categories[index].page);

    // if (nbPosts != posts.length) {
    //   categories[index].currentPage = categories[index].page + 1;
    // }
  }

  _fetchDataSearch(String searchText, int page) async {
    setState(() {
      isLoading = true;
    });
    posts.clear();
    //ApiProvider postsApiProvider = PostsApiProvider();
    Repository repository = Repository();

    posts = await repository.fetchDataSearch(searchText, page);
    setState(() {
      carouselPosts.clear();
      bodyPosts.clear();
      for (var i = 0; i < posts.length; i++) {
        // debugPrint("Post mediaurl :  " + posts[i].featuredMediaUrl);

        bodyPosts.add(posts[i]);
      }

      isLoading = false;
      displayCarousel = false;
    });
  }

  _handleTabSelection() {
    setState(() {
      _selectedDrawerIndex = _tabController.index;
      categories[_selectedDrawerIndex].currentPage = 1;
      _goFetchDataCat(_selectedDrawerIndex);
    });
  }

  _handleSearchSelection() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
      });
    } else {
      setState(() {
        _searchText = _filter.text;
        _fetchDataSearch(_searchText, 1);
      });
    }
  }

  _onSubmitted(String value) {
    if (value.isEmpty) {
      setState(() {
        _searchText = "";
      });
    } else {
      setState(() {
        _searchText = value;
        _fetchDataSearch(_searchText, 1);
      });
    }
  }

  _handleScrollController() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _goFetchDataCat(_selectedDrawerIndex);
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // _scrollController.animateTo(0.0,
      //     curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
    }
  }

  Widget noPost() {
    return Center(
        child: Card(
            elevation: 8,
            child: Text(
              'Désolé. Pas de nouvel article trouvé',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Roboto',
              ),
            )));
  }

  _getPrefs() async {
    _vNotificationsPrefs = await prefs.getAllowsNotifications();
    isSwitched = _vNotificationsPrefs;
  }

  _setPrefs() async {
    _vNotificationsPrefs = await prefs.setAllowsNotifications(isSwitched);
  }

  void _openUrl(String url) async {
    // Close the about dialog.
    Navigator.pop(context);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    bool vAutoPrompt = false;
    TargetPlatform targetPlatform = defaultTargetPlatform;
    if (targetPlatform == TargetPlatform.android) {
      debugPrint("Your Plateform is : " + TargetPlatform.android.toString());
    } else {
      debugPrint("Your Plateform is : " + TargetPlatform.iOS.toString());
      vAutoPrompt = true;
    }

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: vAutoPrompt,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      String title;
      String url;
      title = result.notification.payload.title;
      url = result.notification.payload.body;
      //  result.notification.payload.[title | body]
      debugPrint("Title: " + result.notification.payload.title);
      debugPrint("Body: " + result.notification.payload.body);
      this.setState(() {
        // var data = json.decode(
        //     result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
        // debugPrint("Data: " + data.toString());
        // _debugLabelString =
        //     "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
        // debugPrint("Opened notification: " + _debugLabelString);
        title = result.notification.payload.title;
        url = result.notification.payload.body;
        // Kdr test emptiness of title and url
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowPost(title: title, url: url),
            ));
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .init("6391e82b-62dd-4bbe-a807-161c46351a6c", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    var status = await OneSignal.shared.getPermissionSubscriptionState();

    if (status.permissionStatus.status == OSNotificationPermission.authorized)
    // boolean telling you if the user enabled notifications
    {
      isSwitched = true;
    } else {
      isSwitched = false;
    }
    this.setState(() {
      _enableConsentButton = requiresConsent;
    });
  }

  Widget _getDrawerItemWidget(int pos) {
    if (start) {
      start = !start;
      return FetchDataCat(
          category: categories[pos].id, page: categories[pos].page);
    } else {
      //   Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => FetchDataCat(
              category: categories[pos].id, page: categories[pos].page)));
    }
  }

  @override
  void initState() {
    super.initState();
    initDb();

    _chroniquesTapRecognizer = new TapGestureRecognizer()
      ..onTap = () => _openUrl(chroniquesUrl);
    _defPosts();
    _tabController = new TabController(vsync: this, length: drawerItems.length);
    _tabController.addListener(_handleTabSelection);
    // _filter.addListener(_handleSearchSelection);
    _goFetchDataCat(_selectedDrawerIndex);
    _scrollController.addListener(_handleScrollController);
    initPlatformState();
    _getPrefs();
  }

  @override
  void dispose() {
    _chroniquesTapRecognizer.dispose();
    _githubTapRecognizer.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    postsDbProvider.close();
    super.dispose();
  }

  Widget Body() {
    !displayCarousel
        ? displayBody
            ? Column(children: [
                Expanded(
                    child: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = bodyPosts[index];
                            if (index > bodyPosts.length) return null;
                            return ItemClick(
                                post:
                                    item); // you can add your unavailable item here
                          },
                          //       childCount: bodyPosts.length,
                        ),
                      )
                    ]))
              ])
            : noPost()
        : Column(children: [
            Expanded(
                child: CustomScrollView(
                    controller: _scrollController,
                    reverse: true,
                  shrinkWrap: true,
                    slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      CarouselWithIndicator(carouselPosts),
                    ]),
                  ),
                  displayBody
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index > bodyPosts.length) return null;
                              final item = bodyPosts[index];
                              
                              return ItemClick(
                                  post:
                                      item); // you can add your unavailable item here
                            },
                            //                  childCount: bodyPosts.length,
                          ),
                        )
                      : noPost()
                ]))
          ]);
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
      _tabController.index = index;
      Navigator.of(context).pop(); // close the drawer
      categories[_selectedDrawerIndex].currentPage = 1;
      _goFetchDataCat(index);
    });
  }

  void initDb() {
    postsDbProvider.deleteAllPosts();
    for (var i = 0; i < 3; i++) {
      postsDbProvider.apiRead();
    }
  }

  void clicked(BuildContext context, menu) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(menu),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          onSubmitted: _onSubmitted,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Recherche...'),
        );
        _searchOnProgress = true;
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = Image.asset('images/chroniques-logo.png');

        //      filteredNames = names;
        _filter.clear();
        _searchOnProgress = false;
        _handleTabSelection();
      }
    });
  }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text:
            'Chroniques.sn met à votre dispostion les informations nationales et internationales.\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(text: 'Acceder au site web '),
          new TextSpan(
            text: 'Chroniques.sn',
            recognizer: _chroniquesTapRecognizer,
            style: linkStyle,
          ),
          const TextSpan(
            text:
                ' en activant les notifications vous serez averti de les toutes  '
                'informations importantes ',
          ),
          // new TextSpan(
          //   text: 'www.codesnippettalk.com',
          //   recognizer: _githubTapRecognizer,
          //   style: linkStyle,
          // ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  void _dropDb() async {
    // Assuming that the number of rows is the id for the last row.

    var response = await postsDbProvider.deleteDb();
    print('Db deleted : ' + response.toString());
  }

  Widget _buildLogoAttribution() {
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: new Image.asset(
              'images/chroniques-logo.png',
              width: 32.0,
            ),
          ),
          const Expanded(
            child: const Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: const Text(
                'Version: ',
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          ),
          RaisedButton(
            child: Text(
              'drop db',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _dropDb();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStatus() {
    //   bool isSwitched = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
        ),
        Switch(
          value: isSwitched,
          onChanged: (value) async {
            setState(() {
              isSwitched = value;
              debugPrint("Switch notification : " + isSwitched.toString());
            });
            await _setPrefs();
            await OneSignal.shared.setSubscription(isSwitched);
          },
          activeTrackColor: Colors.blueAccent,
          activeColor: CustomColor.mbluecol,
        )
      ],
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: CustomColor.mgreycol,
      title: const Text('Paramètres'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
          _buildLogoAttribution(),
          _buildNotificationStatus(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    drawerOptions.clear();

    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new Directionality(
          textDirection: TextDirection.ltr,
          child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 35.0,
                // maxHeight: 160.0,
              ),
              child: Card(
                  elevation: 8,
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(color: CustomColor.mgreycol),
                      child: ListTile(
                        //  leading: new Icon(d.icon),
                        title: new Text(
                          d.title,
                          style: TextStyle(fontSize: 12.0),
                        ),
                        selected: i == _selectedDrawerIndex,
                        onTap: () => _onSelectItem(i),
                        trailing: new Icon(Icons.arrow_right),
                      ),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ])))));
    }

    return OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          if (connectivity == ConnectivityResult.none) {
            return Scaffold(
                appBar: AppBar(
                  title: _appBarTitle,
                  //               const Text('Home'),
                ),
                body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text('Vérifiez votre connexion internet!',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      Text('Puis redémarrer votre application',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      RaisedButton(
                        child: Text(
                          'Quitter',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          SystemChannels.platform
                              .invokeMethod<void>('SystemNavigator.pop');
                        },
                      ),
                    ])));
          }
          return child;
        },
        // @override
        // Widget build(BuildContext context) {
        child:

            //   return new
            Scaffold(
                appBar: new AppBar(
                  backgroundColor: CustomColor.mgreycol,
                  title: _appBarTitle,
                  actions: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: _searchIcon,
                      onPressed: _searchPressed,
                    ),
                    IconButton(
                      color: Colors.white,
                      tooltip: 'Paramètres',
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        //       clicked(context, "Notifications");
                        _getPrefs();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildAboutDialog(context),
                        );
                      },
                    ),
                  ],
                  bottom: _searchOnProgress
                      ? PreferredSize(
                          child: Container(),
                          preferredSize: null,
                        )
                      : TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          tabs: drawerItems
                              .map((tab) => Text(tab.title))
                              .toList(),
                          indicatorColor: CustomColor.mbluecol,
                        ),
                ),
                drawer: Drawer(
                    child: ListView(children: <Widget>[
                  StickyHeader(
                      header: Container(
                        decoration: BoxDecoration(color: CustomColor.mgreycol),
                        child: _appBarTitle,
                      ),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                children: drawerOptions,
                              ),
                            )
                          ]))
                ])),
                body: isLoading
                    ? Center(
                        child: new CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColor.mbluecol)))
                    : !displayCarousel
                        ? displayBody
                            ? Column(children: [
                                Expanded(
                                    child: CustomScrollView(
                                        controller: _scrollController,
                                        slivers: <Widget>[
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                             if (index > bodyPosts.length)
                                              return null;
                                            final item = bodyPosts[index];
                                           
                                            return ItemClick(
                                                post: item,
                                                index:
                                                    index); // you can add your unavailable item here
                                          },
                                          childCount: bodyPosts.length,
                                        ),
                                      )
                                    ]))
                              ])
                            : noPost()
                        : Column(children: [
                            Expanded(
                                child: CustomScrollView(
                                    controller: _scrollController,
                                    slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildListDelegate([
                                      CarouselWithIndicator(carouselPosts),
                                    ]),
                                  ),
                                  displayBody
                                      ? SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              if (index > bodyPosts.length)
                                                return null;
                                              final item = bodyPosts[index];
                                              
                                              return ItemClick(
                                                  post: item,
                                                  index:
                                                      index); // you can add your unavailable item here
                                            },
                                            childCount: bodyPosts.length,
                                          ),
                                        )
                                      : SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              return noPost();
                                            },
                                            childCount:
                                                1, // you can add your unavailable item here
                                          ),
                                        )
                                ]))
                          ])));
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  const CustomListTile({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
          leading: const Icon(Icons.flight_land),
          title: Text(title),
          onTap: () {
//       setState(() {
//              //         widget.workers[index].isSelected != widget.workers[index].isSelected
//       /* react to the tile being tapped */
          }),
    );
  }
}
