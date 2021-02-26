import 'dart:convert';

import 'package:catapp_test/cat.dart';
import 'package:http/http.dart' as Http;

class CatService {
  static randomCat() {
    var url = "https://api.thecatapi.com/v1/images/search";
    Http.get(url).then((response) {
      print("Response status: ${response.body}");
    });
  }

  static Future<List<Cat>> getListCat() async {
    Map<String, String> header = new Map();
    header["content-type"] =  "application/json; charset=utf-8";
    header["x-api-key"] =  "6652093d-6cad-480c-bc90-85ab2eb0bf8c";
    var url = "https://api.thecatapi.com/v1/breeds";
    var response = await Http.get(url,headers: header);
/*    Map map = json.decode(response.body);
    Cat msg_cat = Cat.fromJson(map);*/
    if(response.statusCode==200){
      List list = json.decode(response.body);
      List<Cat> list_cat = list.map<Cat>((item) => Cat.fromJson(item)).toList();
      print("URL img = "+ list_cat.first.image.url);
      return list_cat;
    }else {
      throw Exception('Error service Cat');
    }

  }

}