import 'newsingle.dart';

import '../models/category_model.dart';
import '../resources/color.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'dart:math';


class SinglePost extends StatefulWidget {
  final Post post;
  SinglePost({Key key, @required var this.post}) : super(key: key);
  @override
  _SinglePostState createState() => _SinglePostState(post: post);
}
class _SinglePostState extends State<SinglePost> {

  final Post post;
  _SinglePostState({@required var this.post}) ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('fr_Fr');

  }
  
//   final DateFormat _timestamp = new DateFormat('dd/MMM/y HH:mm:ss', 'fr_FR');

// String get timestamp {
//   return _timestamp.format(new DateTime.now());
// }
// initializeDateFormatting().then(){print("oK");};
 
 

  _launchURL(String url) async {
    // const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
// // await     initializeDateFormatting("fr_FR", null);
// initializeDateFormatting();
//     var    dateFormat = new DateFormat.yMMMMd('fr_FR');
//    var     timeFormat = new DateFormat.Hms('fr_FR');
   
    return new Scaffold(
        appBar: new AppBar(

          title: Html(
              data: (post.title.rendered).toString(),
              defaultTextStyle:
                  TextStyle(fontSize: 20.0, decoration: TextDecoration.none)),
          //          new Text(post.title.rendered),
        ),
        body: new Padding(
          padding: EdgeInsets.all(12.0),
          child: Container(
       //     decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
       decoration: BoxDecoration(color: Colors.white),
            child: new ListView(
              children: <Widget>[
                // new FadeInImage.memoryNetwork(
                //   placeholder: kTransparentImage,
                //   image: post.featuredMedia == 0
                //       ? 'images/placeholder.png'
                //       : post.featuredMediaUrl,
                // ),
                Transform.rotate(
  //angle: -pi / 24.0,
  angle: 0.0,
  child: Container(
    height: 35.0,
    width: 60.0,
    // color: Colors.pink,
  

                  alignment: Alignment.center ,
                    margin: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.all( Radius.circular(0.5)),
                        color: CustomColor.mbluecol,
                        border: Border.all(
                            color: Colors.white70, style: BorderStyle.solid)),
                    child: Text(
                        findCategoryById(post.categories[0]) != null
                            ? findCategoryById(post.categories[0]).title
                            : 'A la Une',
                        style: TextStyle(
                          
                          fontSize: 20.0,
                          color: Colors.black54,
                        )))),
                ListTile(
                  title: Html(
                      data: (post.title.rendered).toString(),
                      defaultTextStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          decoration: TextDecoration.none)),
                ),
                ListTile(
                  
                  title: Text(
                      'Par ' +
                          post.author +
                          ", le " +
                          //                formatDate(DateTime(1989, 2, 21), [yy, '-', M, '-', d])
                          //                DateFormat('yyyy-MM-dd – kk:mm')
                          DateFormat('EEE, d MMM yyyy à  kk:mm','fr')
                              .format(post.date)
                              .toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          decoration: TextDecoration.none)),
                ),
                FadeInImage.assetNetwork(
                  placeholder: 'images/placeholder.png',
                  image: post.featuredMediaUrl ??
                      'https://picsum.photos/250?image=9',
                ),
                new Padding(
                    padding: EdgeInsets.all(16.0),
                    child:
                        // new Text(
                        //     post.content.rendered
                        //         .replaceAll(new RegExp(r'<[^>]*>'), ''),
                        //     style: TextStyle(color: Colors.black54))),
                        Html(
                            data: (post.content.rendered).toString(),
                            defaultTextStyle: TextStyle(
                                color: Colors.black54,
                                //         fontFamily: 'NotoKufiArabic',
                                fontSize: 16.0,
                                decoration: TextDecoration.none))),
                Divider(color: Colors.black54),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: new Icon(
                        Icons.share,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        //    print("Pressed");
                        RenderBox box = context.findRenderObject();
                        Share.share(post.link,
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: IconButton(
                  //     icon: new Icon(
                  //       Icons.bookmark,
                  //       color: Colors.black54,
                  //     ),
                  //     onPressed: () {
                  //       print("Pressed");
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: new Icon(
                        Icons.launch,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                     //   _launchURL(post.link);
                     Navigator.push(context,
   //       MaterialPageRoute(builder: (context) => SinglePost(post: post)));
          MaterialPageRoute(
            builder: (context) => 
           NSinglePost(
             post: post)));
                       //NSinglePost(links:List<String>.generate(1, (int index) => post.link));
                        //              print("Pressed");
                      },
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: IconButton(
                  //     icon: new Icon(
                  //       Icons.font_download,
                  //       color: Colors.black54,
                  //     ),
                  //     onPressed: () {
                  //       //             _launchURL(post.link);
                  //       print("Pressed");
                  //     },
                  //   ),
                  // ),
                ])
              ],
            ),
          ),
        ));
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Home', icon: Icons.home),
  CustomPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  CustomPopupMenu(title: 'Settings', icon: Icons.settings),
];
