import '../models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';

// Map allPosts = Map();
// List<Post> newPosts = new List<Post>();

class Category {
  final int id;
  final String title;
  final ColorSwatch color;
  final IconData icon;
  int page;
  bool endReached;

  /// Creates a [Category].
  ///
  /// A [Category] saves the title of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  // While the  checks for whether a titled parameter is passed in,
  // it doesn't check whether the object passed in is null. We check that
  // in the assert statement.
  Category({
    this.id,
    this.title,
    this.color,
    this.icon,
    this.page,
    this.endReached = false,
  });

  int get currentPage => page;

  set currentPage(int value) => page = value;

  bool get endReachedStatus => endReached;

  set endReachedStatus(bool value) => endReached = value;
}
//Map get allPostsList => allPosts ;

List<Category> categories = [
  Category(
    id: 458,
    title: "ACCUEIL",
    color: Colors.red,
    icon: FontAwesomeIcons.home,
    page: 1,
  ),
  Category(
    id: 514,
    title: "ÉCONOMIE",
    color: Colors.red,
    icon: FontAwesomeIcons.landmark,
    page: 1,
  ),
  Category(
    id: 653,
    title: "ENVIRONNEMENT",
    color: Colors.red,
    icon: FontAwesomeIcons.recycle,
    page: 1,
  ),
  Category(
    id: 460,
    title: "INTERNATIONAL",
    color: Colors.red,
    icon: FontAwesomeIcons.globeAsia,
    page: 1,
  ),
  Category(
    id: 570,
    title: "HISTOIRE",
    color: Colors.red,
    icon: FontAwesomeIcons.history,
    page: 1,
  ),
  Category(
    id: 470,
    title: "SOCIETE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 456,
    title: "SPORTS",
    color: Colors.red,
    icon: FontAwesomeIcons.running,
    page: 1,
  ),
  Category(
    id: 468,
    title: "NOS REPORTAGES",
    color: Colors.red,
    icon: FontAwesomeIcons.film,
    page: 1,
  ),
  Category(
    id: 637,
    title: "CULTURE",
    color: Colors.red,
    icon: FontAwesomeIcons.artstation,
    page: 1,
  ),
  Category(
    id: 578,
    title: "INFOS REGIONS",
    color: Colors.red,
    icon: FlatIcons.route,
    page: 1,
  ),
  Category(
    id: 474,
    title: "POLITIQUE/INSTITUTION",
    color: Colors.red,
    icon: FontAwesomeIcons.landmark,
    page: 1,
  ),
  Category(
    id: 536,
    title: "3 QUESTIONS A",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 512,
    title: "CONFIDENCES",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 502,
    title: "CUISINE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 1010,
    title: "SANTÉ MAGASINE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 639,
    title: "LES COUPS DE COEUR DE CHRONIQUES",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 645,
    title: "NOS RÉGIONS ONT DU TALENT",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 1012,
    title: "ECHOS CAMPAGNE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 468,
    title: "GRANDS REPORTAGES",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 643,
    title: "HISTOIRE ET TRADITION",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 641,
    title: "L’HISTOIRE DU SENEGAL",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 478,
    title: "L’INVITÉ DE LA REDACTION",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 462,
    title: "LE SHOW DE NITA",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 1005,
    title: "MICRO TROTTOIR",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 1011,
    title: "NECROLOGIE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 466,
    title: "CHRONIQUES PEOPLE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 531,
    title: "SECRET DE LA REUSSITE",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  ),
  Category(
    id: 500,
    title: "UN WEEK END AVEC ",
    color: Colors.red,
    icon: FontAwesomeIcons.atom,
    page: 1,
  )
];

Category findCategoryById(int id) {
  for (var i = 0; i < categories.length; i++) {
    if (categories[i].id == id) {
      return categories[i];
    }
  }
  return categories[0];
}

int findCategoryIndexById(int id) {
  for (var i = 0; i < categories.length; i++) {
    if (categories[i].id == id) {
      return i;
    }
  }
  return null;
}
