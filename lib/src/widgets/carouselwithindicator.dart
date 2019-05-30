import 'package:carousel_slider/carousel_slider.dart';
import '../models/post_model.dart';
import '../resources/color.dart';
import '../widgets/single.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;

// final List<String> titleList = [
//   "Éjecté des Domaines : Mamour Diallo vers la Crei ?",
//   "MODOU DIAGNE FADA NOUVEAU DIRECTEUR GÉNÉRAL DE LA SONACOS",
//   "La Caisse des dépôts et consignations lance sa «Tour des Mamelles» à 38 milliards Fcfa. La Caisse des dépôts et consignations lance sa «Tour des Mamelles» à 38 milliards Fcfa",
//   "Communiqué du Conseil des ministres du 24 avril 2019",
//   "HISSEIN HABRE débouté par la cour d’appel.",
//   "BABACAR GAYE N’EST PLUS PORTE PAROLE DU PDS SUR DÉCISION DE MAÎTRE ABDOULAYE WADE."
// ];

// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
// ];

List<String> imgList = [];
List<String> titleList = [];
List<DateTime> dateList = [];
List<Post> postList = [];
List child = [];

class CarouselWithIndicator extends StatefulWidget {
  final List<Post> posts;
  CarouselWithIndicator(this.posts);
  @override
  _CarouselWithIndicatorState createState() =>
      _CarouselWithIndicatorState(posts: this.posts);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final List<Post> posts;
  _CarouselWithIndicatorState({this.posts});


 _initImgList() {
   imgList.clear();
 }
  _initTitleList() {
   titleList.clear();
 }

  _initDateList() {
   dateList.clear();
 }

  _initPostList() {
   postList.clear();
 }
  _setImgList() {
    _initImgList();
    for (var i = 0; i < posts.length; i++) {
      imgList.add(posts[i].featuredMedia == 0 ? 'https://picsum.photos/250?image=9' :  posts[i].featuredMediaUrl );
    }
  }

  _setTitleList() {
    _initTitleList();
    for (var i = 0; i < posts.length; i++) {
      titleList.add(posts[i].title.rendered);
    }
  }

   _setDateList() {
    _initDateList();
    for (var i = 0; i < posts.length; i++) {
      dateList.add(posts[i].date);
    }
  }

   _setPostList() {
    _initPostList();
    for (var i = 0; i < posts.length; i++) {
      postList.add(posts[i]);
    }
  }

  final Widget placeholder = Container(color: Colors.grey);
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _setImgList();
    _setTitleList();
     _setDateList();
    
  }
  @override
  Widget build(BuildContext context) {
   timeago.setLocaleMessages('fr', timeago.FrMessages());
   setChild(posts,context) ;
    return Column(children: [
      CarouselSlider(
        items: child,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          imgList,
          (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
    ]);
  }
}

//class CarouselDemo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        title: 'demo',
//        home: Scaffold(
//            appBar: AppBar(title: Text('Carousel slider demo')),
//            body: ListView(children: <Widget>[
//              Padding(
//                  padding: EdgeInsets.symmetric(vertical: 15.0),
//                  child: Column(children: [
//                    Text('Carousel With Indecator'),
//                    CarouselWithIndicator(),
//                  ])),
//            ])));
//  }
//}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

setChild(List<Post>posts, BuildContext context) {
  timeago.setLocaleMessages('fr', timeago.FrMessages());
 child = map<Widget>(
  imgList,
  (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
              InkWell(
                onTap: () {
                   Navigator.push(context,
            MaterialPageRoute(builder: (context) => SinglePost(post: posts[index])));
                },
                child:
                 Html(
                            data: titleList[index].toString(),
                            defaultTextStyle: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                decoration: TextDecoration.none)),
                //  Text(
                //   titleList[index],
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   //              'No. $index image',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 12.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ),
               Text(
                        timeago.format(dateList[index], locale: 'fr'),
                        //             post.date.toString(),
                        //'Il y a 2h',
                        
                            style: TextStyle(
         //                     Theme.of(context).accentColor,
                    color: CustomColor.mbluecol,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal)),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();
}