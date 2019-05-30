import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ShowPost extends StatelessWidget {
  final String title;
  final String url;

  const ShowPost({Key key, this.title, this.url}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return            WebviewScaffold(
      scrollBar: true,
      withJavascript: true,
      url: url,
           appBar: AppBar(
              title: 
              Html(
              data: (title),
              defaultTextStyle:
                  TextStyle(fontSize: 20.0, decoration: TextDecoration.none)),
 //             Text(post.title.rendered),
           ),

);
    
  }
}