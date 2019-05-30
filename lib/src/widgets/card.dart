import 'newsingle.dart';
import 'package:flutter/material.dart';
// import 'package:html/dom.dart';
// import 'package:html/dom_parsing.dart';
// import 'package:html/parser.dart';
import '../models/post_model.dart';
import '../widgets/single.dart';
// import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:timeago/timeago.dart' as timeago;
//import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard(this.post);

  @override
  _PostCardState createState() => _PostCardState(post);
}

class _PostCardState extends State<PostCard> {
  Post post;

  _PostCardState(this.post);

  @override
  Widget build(BuildContext context) {
    return
        // makeCard(post);
        Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: new Text(post.title.rendered),
        // subtitle: new Text(post.excerpt.rendered),
        subtitle: new Text(post.featuredMediaUrl),
      ),
    );
  }

  // Container makeListTile(Post post) => Container(
  //   padding: EdgeInsets.all(12.0),
  //   child :
  //   Column(
  //      mainAxisSize: MainAxisSize.min,
  //   children: [
  //       post.featuredMedia == 0 ? new Container(width: 0, height: 0) :
  //       FadeInImage.assetNetwork(
  //         placeholder: 'images/placeholder.png',
  //         image: post.featuredMediaUrl ?? 'https://picsum.photos/250?image=9',
  //       ),
  //       ListTile(
  //         contentPadding:
  //             EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //         leading: Container(
  //             padding: EdgeInsets.only(right: 12.0),
  //             decoration: new BoxDecoration(
  //                 border: new Border(
  //                     right:
  //                         new BorderSide(width: 1.0, color: Colors.white24))),
  //             child:
  //              Icon(Icons.autorenew, color: Colors.white),
  //             ),
  //         title: Text(
  //           post.title.rendered,
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         ),
  //         // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
  //         subtitle: Text(post.excerpt.rendered.replaceAll(new RegExp(r'<[^>]*>'), ''),
  //             style: TextStyle(color: Colors.white)),
  //       ),
  //       ListTile(
  //         title: Text(post.author, style: TextStyle(color: Colors.white)),
  //         subtitle: Text(
  //             DateFormat('MM-dd – kk:mm').format(post.date).toString(),
  //             style: TextStyle(color: Colors.white)),
  //         trailing:
  //             Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
  //         onTap: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => SinglePost(post: post)));
  //         },
  //       )
  //     ])
  // );
  Container makeListTile(Post post) => Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: post.featuredMedia == 0
                    ? new Container(width: 0, height: 0)
                    : FadeInImage.assetNetwork(
                        placeholder: 'images/placeholder.png',
                        image: post.featuredMediaUrl ??
                            'https://picsum.photos/250?image=9',
                        height: 60.0,
                        fit: BoxFit.cover,
                      ),
              ),
              new Container(
                  child: ListTile(
                title: Text(post.title.rendered,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    DateFormat('MM-dd – kk:mm').format(post.date).toString(),
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SinglePost(post: post)));
                },
              )),
            ],
          ),
        ],
      ));

  Card makeCard(Post post) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(post),
        ),
      );
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

class ItemClick extends StatelessWidget {
  final Post post;
  ItemClick({this.post});
  //var unescape = new HtmlUnescape();
//  var text = unescape.convert("&lt;strong&#62;This &quot;escaped&quot; string");

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    // The InkWell Wraps our custom flat button Widget
    return InkWell(
      // When the user taps the button, show a snackbar
      onTap: () {
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text('Tap'),
        // ));
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => SinglePost(post: post)));
  //            MaterialPageRoute(builder: (context) => NSinglePost(links: post.link)));
      },
      child: Center(
        //       child: Container(
//  //   margin: EdgeInsets.all(2.0),
//          padding: EdgeInsets.all(2.0),
//          decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
        child: Card(
          elevation: 8.0,
          child: Container(
//            child: Container(
//
            margin: const EdgeInsets.all(4.0),
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.redAccent)),

            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: FadeInImage.assetNetwork(
                    width: 120.0,
                    height: 80.0,
                    fit: BoxFit.fill,
                    placeholder: 'images/placeholder.png',
                    // image: 'https://picsum.photos/250?image=9',
                    image: post.featuredMediaUrl ??
                        'https://picsum.photos/250?image=9',
                  )),
              Expanded(
                flex: 9,
                child: Container(
//                     padding: EdgeInsets.only(bottom:2.0),
                  padding: EdgeInsets.all(1.0),
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.blueAccent)),
                  child: ListTile(
                    title:
                        //                 AutoSizeText(post.title.rendered,
                        Html(
                            data: (post.title.rendered).toString(),
                            defaultTextStyle: TextStyle(
                                //         fontFamily: 'NotoKufiArabic',
                                fontSize: 16.0,
                                decoration: TextDecoration.none)),
//                      unescape.convert(post.title.rendered),
                    //                       'Voici des plus gros titres encore ! et encore. Voici des plus gros titres encore ! et encore  Voici des plus gros titres encore! ',
                    // textAlign: TextAlign.left,
                    // maxLines: 5,
                    // overflow: TextOverflow.ellipsis,
                    // style: TextStyle(

                    //   color: Colors.black54,
                    //   fontSize: 12.0,
                    //   fontStyle: FontStyle.normal,
                    //         fontWeight: FontWeight.w900,
                    // )),
                    subtitle: AutoSizeText(
                        timeago.format(post.date, locale: 'fr'),
                        //             post.date.toString(),
                        //'Il y a 2h',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal)),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      //     ),
      //       ),
//      ),
    );
  }
}
