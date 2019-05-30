import 'dart:async';
import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'repository.dart';

import '../models/post_model.dart';
import 'package:http/http.dart' show Client;

const PER_PAGE = 20;
const baseUrl = "http://chroniques.sn";
//const baseUrl = "https://lemedia.sn";

class PostsApiProvider implements Source {


  @override
  Future<Post> fetchItem(int id) {
    // TODO: implement fetchItem
    return null;
  }

  @override
  Future<List<Post>> fetchDataCat(int category, int page) async {
    Client client = Client();
    var url;
    // List<Post> posts = new List<Post>();
    category == 1
        ? url = baseUrl +
            "/wp-json/wp/v2/posts?_embed&per_page=" +
            PER_PAGE.toString() +
            "&page=" +
            page.toString()
        : url = baseUrl +
            "/wp-json/wp/v2/posts?categories=" +
            category.toString() +
            "&page=" +
            page.toString() +
            "&_embed&per_page=" +
            PER_PAGE.toString();
    var response = await client.get(url);
    var parsedJson = json.decode(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
    var posts = parsedJson.map((model) => Post.fromJson(model)).toList();
    List<Post> x = posts.cast<Post>();
    return x;
    }
    else return null;
  }

  @override
  Future<List<Post>> fetchDataSearch(String searchText, int page) async {
    Client client = Client();
    var url;
    url = baseUrl +
        "/wp-json/wp/v2/posts?_embed&per_page=" +
        PER_PAGE.toString() +
      //  "&?page=" +
      //  page.toString() +
        "&search=" +
        searchText;
debugPrint("Url : $url");
    var response = await client.get(url);
    var parsedJson = json.decode(response.body);
    var posts = parsedJson.map((model) => Post.fromJson(model)).toList();
    List<Post> x = posts.cast<Post>();
    return x;
  }
}
