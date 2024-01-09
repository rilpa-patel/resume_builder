import 'package:shared_preferences/shared_preferences.dart';

import '../models/ResumeItem.dart';


class DataStorage {
  Future<void> StoreData(List<ResumeItem> resumeItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = resumeItems.map((item) => item.title).toList();
    List<String> contents = resumeItems.map((item) => item.content).toList();

    prefs.setStringList('titles', titles);
    prefs.setStringList('contents', contents);
  }

  Future<List<String>?> readTitels() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? titles = prefs.getStringList('titles') ;
    return titles;
  }

  Future<List<String>?> readContant() async{
    final prefs = await SharedPreferences.getInstance();
     List<String>? contents = prefs.getStringList('contents');
    return contents;
  }

}