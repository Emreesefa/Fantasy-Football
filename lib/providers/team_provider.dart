import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';

class TeamProvider with ChangeNotifier {
  List<Player> _selectedPlayers = [];

  List<Player> get selectedPlayers => _selectedPlayers;

  void addPlayer(Player player) {
    _selectedPlayers.add(player);
    notifyListeners();
    _saveToPrefs();
  }

  void removePlayer(Player player) {
    _selectedPlayers.remove(player);
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Burada _selectedPlayers listesini yükle
  }

  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Burada _selectedPlayers listesini kaydet
  }
}
