import 'dart:convert';

class Project{
  String name;
  String id;
  List component;

  Project({
    this.name,
    this.id,
    this.component
  });

  Map<String, dynamic> toJson() {
    var myMap = {
      "komponenten": this.component,
      "id": " "
    };
    return {
      this.name: myMap
    };
  }

  factory Project.fromJson(Map<String, dynamic> item) {
    var entryList = item.entries.toList();
    return Project(
        name: entryList[0].key,
        id: entryList[0].value['id'].toString(),
        component: json.decode(entryList[0].value['komponenten'].toString())
    );
  }
}