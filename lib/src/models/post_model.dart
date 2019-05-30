import 'dart:convert';

class Post {
  // final String title;
  // final String thumbnailUrl;
  int id;
  DateTime date;
  Guid title;
  Content content;
  Content excerpt;
  String author;
  int featuredMedia;
  dynamic featuredMediaUrl;
  String link;
  List<int> categories;
  // Embedded embedded;

  // Post.posts({this.title, this.thumbnailUrl});
  Post({
    this.id,
    this.date,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.featuredMediaUrl,
    this.link,
    this.categories,
    // this.embedded,
  });

  void setPostId(int id) {
    this.id = id;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json["id"],
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      title: Guid.fromJson(json["title"]),
      content: Content.fromJson(json["content"]),
      excerpt: Content.fromJson(json["excerpt"]),
      author: json["_embedded"]["author"][0]["name"],
      featuredMedia: json["featured_media"],
      featuredMediaUrl: json["_embedded"]["wp:featuredmedia"] == null
          ? 'images/placeholder.png'
          : json["_embedded"]["wp:featuredmedia"][0]["source_url"],
      link: json["link"],
      categories: new List<int>.from(json["categories"].map((x) => x)),
    );
    // thumbnailUrl: json['thumbnailUrl'],
  }

  factory Post.fromDb(Map<String, dynamic> parsedJson) {
    return new Post(
      id: parsedJson["id"],
      date: parsedJson["date"] != null
          ? DateTime.parse(parsedJson["date"])
          : null,
      title: Guid.fromString(parsedJson["title"]),
      content: Content.fromString( parsedJson["content"]),
      excerpt: Content.fromString(  parsedJson["excerpt"]),
      author: parsedJson["author"],
      featuredMedia: parsedJson["featuredMedia"],
      featuredMediaUrl: parsedJson["featuredMediaUrl"],
      link: parsedJson["link"],
      //    categories: jsonDecode(parsedJson["categories"]),
      categories: (jsonDecode(parsedJson["categories"])).cast<int>(),
    );
    // thumbnailUrl: parsedJson['thumbnailUrl'],
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date?.toIso8601String(),
        "title": title.rendered,
        "content": content.rendered,
        "excerpt": excerpt.rendered,
        "author": author,
        "featuredmedia": featuredMedia,
        "featuredMediaUrl": featuredMediaUrl,
        "link": link,
        //       "categories": new List<dynamic>.from(categories.map((x) => x)),
        "categories": jsonEncode(categories),
      };
}

class Content {
  String rendered;
  bool protected;

  Content({
    this.rendered,
    this.protected,
  });

  factory Content.fromJson(Map<String, dynamic> json) => new Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
      factory Content.fromString(String json) => new Content(
        rendered: json,
        protected: true,
      );
}

class Guid {
  String rendered;

  Guid({
    this.rendered,
  });

  factory Guid.fromJson(Map<String, dynamic> json) => new Guid(
        rendered: json["rendered"],
      );
  factory Guid.fromDb(Map<String, dynamic> json) => new Guid(
        rendered: json["rendered"],
      );
  factory Guid.fromString(String json) => new Guid(rendered: json);

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
      };
}

// class Embedded {
//     List<Author> author;
//     List<WpFeaturedmedia> wpFeaturedmedia;

//     Embedded({
//         this.author,
//         this.wpFeaturedmedia,
//     });

//     factory Embedded.fromJson(Map<String, dynamic> json) => new Embedded(
//         author: new List<Author>.from(json["author"].map((x) => Author.fromJson(x))),
//         wpFeaturedmedia: new List<WpFeaturedmedia>.from(json["wp:featuredmedia"].map((x) => WpFeaturedmedia.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "author": new List<dynamic>.from(author.map((x) => x.toJson())),
//         "wp:featuredmedia": new List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
//     };
// }

// class Author {
//     int id;
//     String name;
//     String url;
//     String description;
//     String link;
//     String slug;
//     Map<String, String> avatarUrls;
//     Links links;

//     Author({
//         this.id,
//         this.name,
//         this.url,
//         this.description,
//         this.link,
//         this.slug,
//         this.avatarUrls,
//         this.links,
//     });
//     factory Author.fromJson(Map<String, dynamic> json) => new Author(
//         id: json["id"],
//         name: json["name"],
//         url: json["url"],
//         description: json["description"],
//         link: json["link"],
//         slug: json["slug"],
//         avatarUrls: new Map.from(json["avatarpostsurls"]).map((k, v) => new MapEntry<String, String>(k, v)),
//         links: Links.fromJson(json["postslinks"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "url": url,
//         "description": description,
//         "link": link,
//         "slug": slug,
//         "avatarpostsurls": new Map.from(avatarUrls).map((k, v) => new MapEntry<String, dynamic>(k, v)),
//         "postslinks": links.toJson(),
//     };
// }

// class Links {
//     List<Collection> self;
//     List<Collection> collection;

//     Links({
//         this.self,
//         this.collection,
//     });

//     factory Links.fromJson(Map<String, dynamic> json) => new Links(
//         self: new List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
//         collection: new List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "self": new List<dynamic>.from(self.map((x) => x.toJson())),
//         "collection": new List<dynamic>.from(collection.map((x) => x.toJson())),
//     };
// }

// class Collection {
//     String href;

//     Collection({
//         this.href,
//     });

//     factory Collection.fromJson(Map<String, dynamic> json) => new Collection(
//         href: json["href"],
//     );

//     Map<String, dynamic> toJson() => {
//         "href": href,
//     };
// }

// class WpFeaturedmedia {
//     int id;
//     DateTime date;
//     String slug;
//     String type;
//     String link;
//     Title title;
//     String sourceUrl;

//     WpFeaturedmedia({
//         this.id,
//         this.date,
//         this.slug,
//         this.type,
//         this.link,
//         this.title,
//         this.sourceUrl,
//     });

//     factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) => new WpFeaturedmedia(
//         id: json["id"],
//         date: DateTime.parse(json["date"]),
//         slug: json["slug"],
//         type: json["type"],
//         link: json["link"],
//         title: Title.fromJson(json["title"]),
//         sourceUrl: json["sourcepostsurl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "date": date.toIso8601String(),
//         "slug": slug,
//         "type": type,
//         "link": link,
//         "title": title.toJson(),
//         "sourcepostsurl": sourceUrl,
//     };
// }

// class Title {
//     String rendered;

//     Title({
//         this.rendered,
//     });

//     factory Title.fromJson(Map<String, dynamic> json) => new Title(
//         rendered: json["rendered"],
//     );

//     Map<String, dynamic> toJson() => {
//         "rendered": rendered,
//     };
// }
