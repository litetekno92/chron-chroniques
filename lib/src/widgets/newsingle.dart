import '../models/post_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'WebViewContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NSinglePost extends StatelessWidget {
  // final _links = ['https://google.com'];
 // final List<String> links;
  final Post post;
  NSinglePost({this.post});
  
  // dispose(){
  //   flutterWebviewPlugin.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return
    WebviewScaffold(
      scrollBar: true,
      withJavascript: true,
      url: post.link,
           appBar: AppBar(
              title: 
              Html(
              data: (post.title.rendered).toString(),
              defaultTextStyle:
                  TextStyle(fontSize: 20.0, decoration: TextDecoration.none)),
 //             Text(post.title.rendered),
           ),

);
    //  Scaffold(
    //     body:
  //        SafeArea(
  //           child: SingleChildScrollView(
  //               child:
  //         //        Column(
  //         //           mainAxisAlignment: MainAxisAlignment.center,
  //         //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //         //           // children: links.map((link) => _urlButton(context, link)).toList(),
  //         //           children: [
  //         // //    _urlButton(context, links[0]),
  //          MaterialApp(
  //     // routes: {
  //     //   "/": (_) =>    
  //     home:     
  //        WebviewScaffold(
  //          url: post.link,
  //          appBar: AppBar(
  //             title: Text(post.title.rendered),
  //          ),

  //        )
        
  //  //   }
  //     )
  //       ));
  }

  Widget _urlButton(BuildContext context, String url) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child: Text(url),
          onPressed: () => _handleURLButtonPress(context, url),
        ));
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
