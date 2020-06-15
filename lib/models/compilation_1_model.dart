import 'dart:convert';

class Compilation1Model{
  String name;
  String id;
  List component;

  Compilation1Model({
    this.id,
    this.name,
    this.component
  });
  Map<String, dynamic> toJson() {
    var myMap = {
      "id": this.id,
      "fehler": this.component,
    };
    return {
      this.name: myMap
    };
  }

  factory Compilation1Model.fromJson(Map<String, dynamic> item) {
    var entryList = item.entries.toList();
    return Compilation1Model(
        name: entryList[0].key,
        id:entryList[0].value['id'].toString(),
        component: json.decode(entryList[0].value['komponenten'].toString())
    );
  }
}