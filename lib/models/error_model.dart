import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ErrorModel{
  String status;
  String beschreibung;
  String qs_bearbeiter;
  DateTime createDateTime;
  List errorCategories;
  String sw_beschreibung;
  String sw_bearbeiter;
  DateTime sw_datum;
  List causeOfError;
  String id;
  String key;


String toSJson(){

  return "$key{'id': $id, 'qs_beschreibung': $beschreibung  }";
}
  Map<String, dynamic> toJson() {
  String update = "";

      update = this.sw_datum.toString();

    var myMap = {
      "status": this.status,
      "qs_beschreibung": this.beschreibung,
      "qs_bearbeiter": this.qs_bearbeiter,
      "qs_datum": this.createDateTime.toString(),
      "fehlerkategorien": this.errorCategories,
      "sw_beschreibung": this.sw_beschreibung,
      "sw_bearbeiter": this.sw_bearbeiter,
      "sw_datum": update,
      "fehlerursache": this.causeOfError,
      "id": this.id
    };
    //return error.toMap();
    return {
      this.key: myMap
    };
  }

  ErrorModel({
    this.status,
    this.beschreibung,
    this.qs_bearbeiter,
    this.createDateTime,
    this.errorCategories,
    this.sw_beschreibung,
    this.sw_bearbeiter,
    this.sw_datum,
    this.causeOfError,
    this.id,
    this.key,
});

  factory ErrorModel.fromJson(Map<String, dynamic> item) {
    var entryList = item.entries.toList();

    return ErrorModel(

      key:entryList[0].key,

      id: entryList[0].value['id'].toString(),
      beschreibung:entryList[0].value['qs_beschreibung'],
      sw_beschreibung: entryList[0].value['sw_beschreibung'],
      createDateTime: DateTime.parse(entryList[0].value['qs_datum']),
      sw_datum: entryList[0].value['sw_datum'] != "null"
          ? DateTime.parse(entryList[0].value['sw_datum'])
          : null,
      status: entryList[0].value['status'],
        errorCategories: json.decode(entryList[0].value['fehlerkategorien'].toString()),
      sw_bearbeiter: entryList[0].value['sw_bearbeiter'],
      causeOfError: json.decode(entryList[0].value['fehlerursache'].toString()),
    );
  }




}