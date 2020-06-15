import 'dart:convert';

class ComponentModel{
  String name;
  List erros;
  String id;

  ComponentModel({
    this.id,
    this.name,
    this.erros
});
  Map<String, dynamic> toJson() {
    var myMap = {
      "id": this.id,
      "fehler": this.erros,
    };
    return {
      this.name: myMap
    };
  }

  factory ComponentModel.fromJson(Map<String, dynamic> item) {
    var entryList = item.entries.toList();
    return ComponentModel(
        name: entryList[0].key,
      id:entryList[0].value['id'].toString(),
      erros: json.decode(entryList[0].value['fehler'].toString())
    );
  }
}