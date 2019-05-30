import 'dart:convert';

import '../models/category_model.dart';
import '../resources/color.dart';



import '../resources/repository.dart';

import '../widgets/carouselwithindicator.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../resources/posts_api_provider.dart';
import '../widgets/card.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';

_FetchDataCatState globalState = _FetchDataCatState( categories[0].id,  categories[0].page);

class FetchDataCat extends StatefulWidget {
  final int category;
  final int page;

  FetchDataCat( {this.category, this.page});
  @override
  _FetchDataCatState createState() =>
      _FetchDataCatState(this.category, this.page);
}

class _FetchDataCatState extends State<FetchDataCat> {
  final int category;
  final int page;
  _FetchDataCatState(this.category, this.page);
  // List<Post> list = List();
  var posts = new List<Post>();
  var isLoading = false;
  var displayCarousel = true;
  var carouselPosts = new List<Post>();
  var bodyPosts = new List<Post>();
  String searchText = "";
  ScrollController _controller = ScrollController(); // instance variable

  _fetchDataCat(int category, int page) async {
    setState(() {
      isLoading = true;
    });
    posts.clear();
  //ApiProvider postsApiProvider = PostsApiProvider();
 Repository repository = Repository();

    posts = await repository.fetchDataCat(category, page);
    setState(() {
      carouselPosts.clear();
      bodyPosts.clear();
      for (var i = 0; i < posts.length; i++) {
        if ((i < 6) &&
            (posts[i].featuredMedia != 0) &&
            (posts[i].featuredMediaUrl != null)) {
          posts[i].featuredMediaUrl =
              posts[i].featuredMediaUrl ?? 'https://picsum.photos/250?image=9';
          carouselPosts.add(posts[i]);
          //  debugPrint("Post mediaurl :  " + posts[i].featuredMediaUrl);
        } else {
          bodyPosts.add(posts[i]);
        }
      }
      //  debugPrint("Posts Length :  " + posts.length.toString());
      //  debugPrint("bodyPosts Length :  " + bodyPosts.length.toString());
      // debugPrint("carouselPosts Length :  " + carouselPosts.length.toString());
      isLoading = false;
    });
  }

// transform(UTF8.decoder)
  initState() {
    super.initState();
    //     initializeDateFormatting();
    // await initializeDateFormatting("ar_SA", null);
    _fetchDataCat(this.category, this.page);
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0)
          debugPrint("At extreme top");
        else
          debugPrint("At extreme bottom");
      }
    });
  }

  dispose() {
  _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (searchText != ""){
        _fetchDataCat(1, 1);
        displayCarousel = false;
    }
    return  Scaffold(
        // appBar: 
        // CustomAppBar(),
        
        //CustomAppBar(),
        // AppBar(
        //   title: Text("chrmock3 Sn FetchDataCat"),
        // ),
        // drawer:
        //     //     CustomDrawer(),
        //     SideDrawer(),
        body: isLoading
            ? Center(
                child: new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(CustomColor.mbluecol))
              )
            : 
  !displayCarousel ?
  Column(children: [
                Expanded(
                    child: CustomScrollView(
                        controller: _controller,
                        slivers: <Widget>[
                      // SliverList(
                      //   delegate: SliverChildListDelegate([
                      //     CarouselWithIndicator(carouselPosts),
                      //   ]),
                      // ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = bodyPosts[index];
                            if (index > bodyPosts.length) return null;
                            return ItemClick(
                                post:
                                    item); // you can add your unavailable item here
                          },
                          childCount: bodyPosts.length,
                        ),
                      )
                    ]))
              ])
          
           : Column(children: [
                Expanded(
                    child: CustomScrollView(
                        controller: _controller,
                        slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          CarouselWithIndicator(carouselPosts),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = bodyPosts[index];
                            if (index > bodyPosts.length) return null;
                            return ItemClick(
                                post:
                                    item); // you can add your unavailable item here
                          },
                          childCount: bodyPosts.length,
                        ),
                      )
                    ]))
              ])
        //           : CarouselWithIndicator(),
        //    Text("chrmock3 Sn FetchDataCat"),
        // : ListView.builder(
        //     itemCount: carouselPosts.length,
        //     itemBuilder: (context, index) {
        //     //  var item = carouselPosts[index];

        //       return CarouselWithIndicator(item: carouselPosts[index]);
        //       // return            ItemClick(post: bodyPosts[index]);
        //     }));
        //       : ListView.builder(
        //           itemCount: bodyPosts.length,
        //           itemBuilder: (context, index) {
        //             // var photo= posts[index];

        // //            return PostCard(bodyPosts[index]);
        // return            ItemClick(post: bodyPosts[index]);
        //           }));

        //     child: ListTile(
        //         contentPadding: EdgeInsets.all(10.0),
        //         title: new Text(posts[index].title),
        //         trailing: new Image.network(
        //           posts[index].thumbnailUrl,
        //           fit: BoxFit.cover,
        //           height: 40.0,
        //           width: 40.0,
        //         )),
        //   );
        // },
        //     )
        // );
        );
    
}
}


