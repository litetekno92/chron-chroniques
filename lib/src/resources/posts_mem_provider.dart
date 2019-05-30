import 'dart:async';
import 'dart:convert';
//import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import 'package:flutter/foundation.dart';

import 'repository.dart';

import '../models/post_model.dart';
import 'package:http/http.dart' show Client;

const PER_PAGE = 20;
const baseUrl = "http://chroniques.sn";
//const baseUrl = "https://lemedia.sn";
var allPosts;
var newPosts;

class PostsMemProvider implements Source, Cache {


  @override
  Future<Post> fetchItem(int id) {
    // TODO: implement fetchItem
    return null;
  }

  @override
  Future<List<Post>> fetchDataCat(int category, int page) async {
   
    var categoryIndex = findCategoryIndexById(category);
     List<Post> posts = allPosts[categories[categoryIndex].title];
    
    return posts;
    
    
  }

  @override
  Future<List<Post>> fetchDataSearch(String searchText, int page) async {
    Client client = Client();
    var url;
    url = baseUrl +
        "/wp-json/wp/v2/posts?_embed&per_page=" +
        PER_PAGE.toString() ;
      //  "&?page=" +
      //  page.toString() +
        // "&search=" +
        // searchText;
debugPrint("Url : $url");
    var response = await client.get(url);
    var parsedJson = json.decode(response.body);
    var posts = parsedJson.map((model) => Post.fromJson(model)).toList();
    List<Post> x = posts.cast<Post>();
    return x;
  }

  @override
  Future<int> addPosts(category,List<Post> posts) async {
    var categoryIndex = findCategoryIndexById(category);
    // allPosts[categories[categoryIndex].title].clear();
    allPosts[categories[categoryIndex].title].addAll(newPosts);
    return allPosts.length;
  }

  @override
  Future<int> clear() async {
    for (var i = 0; i < categories.length; i++)
      allPosts[categories[i].title].clear();
    return allPosts.length;
  }
}
