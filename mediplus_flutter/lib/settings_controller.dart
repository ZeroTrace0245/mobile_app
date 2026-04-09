import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  bool _aiEnabled = true;
  bool _alwaysShowNav = true;
  int _cardColor = 0xFF1E3C72;
  String _githubToken = "";
  bool _biometricsEnabled = false;

  bool get aiEnabled => _aiEnabled;
  bool get alwaysShowNav => _alwaysShowNav;
  int get cardColor => _cardColor;
  String get githubToken => _githubToken;
  bool get biometricsEnabled => _biometricsEnabled;

  SettingsController() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _aiEnabled = prefs.getBool('ai_enabled') ?? true;
    _alwaysShowNav = prefs.getBool('always_show_nav') ?? true;
    _cardColor = prefs.getInt('card_color') ?? 0xFF1E3C72;
    _githubToken = prefs.getString('github_token') ?? "";
    _biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;
    notifyListeners();
  }

  Future<void> setBiometricsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometrics_enabled', value);
    _biometricsEnabled = value;
    notifyListeners();
  }

  Future<void> setAiEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ai_enabled', value);
    _aiEnabled = value;
    notifyListeners();
  }

  Future<void> setAlwaysShowNav(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('always_show_nav', value);
    _alwaysShowNav = value;
    notifyListeners();
  }

  Future<void> setCardColor(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('card_color', value);
    _cardColor = value;
    notifyListeners();
  }

  Future<void> setGithubToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('github_token', value);
    _githubToken = value;
    notifyListeners();
  }
}
