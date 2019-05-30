import 'dart:async';

import './posts_mem_provider.dart';

import '../models/post_model.dart';

import './posts_api_provider.dart';
import 'posts_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    //  postDbProvider,
    //PostsMemProvider(),
    postsDbProvider,
    PostsApiProvider(),
  ];
  List<Cache> caches = <Cache>[
    // postDbProvider,
   // PostsMemProvider(),
   postsDbProvider
  ];

  Future<List<Post>> fetchDataCat(int category, int page) async {
    List<Post> posts;
    var source;

    for (source in sources) {
      posts = await source.fetchDataCat(category, page);
      if (posts != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addPosts(category, posts);
      }
    }

    return posts;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }

  Future<List<Post>> fetchDataSearch(String searchText, int page) async {
    List<Post> posts;
    var source;

    for (source in sources) {
      posts = await source.fetchDataSearch(searchText, page);
      if (posts != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        // ?????????????????????????????????
        cache.addPosts(1,posts);
      }
    }

    return posts;
  }
}

abstract class Source {
//  Future<List<int>> fetchTopIds();
//  Future<Post> fetchItem(int id);
  Future<List<Post>> fetchDataCat(int category, int page);
  Future<List<Post>> fetchDataSearch(String searchText, int page);
}

abstract class Cache {
  Future<int> addPosts(int category, List<Post> posts);
  // Future<int> addItem(Post post);
  Future<int> clear();
}
