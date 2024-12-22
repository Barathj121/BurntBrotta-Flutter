import 'package:flutter/cupertino.dart';
import 'food.dart';

class Favourites extends ChangeNotifier{
  List<Food> _favs = [];

  // getter methods
  List<Food> get favs => _favs;

  void addtofavs(Food food){
    if (!_favs.contains(food)){
      _favs.add(food);
    }

    notifyListeners();
  }

  void removefromfavs(Food food) {
    if (_favs.contains(food)) {
      _favs.remove(food);
      notifyListeners();
    }
  }

}
