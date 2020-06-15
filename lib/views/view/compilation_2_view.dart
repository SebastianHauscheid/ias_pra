
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/compilation_1_model.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/projekt_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class Compilation2View extends StatefulWidget {


  List<Compilation1Model> note;
  List<String> com = [];
  @override
  _Compilation2ViewState createState() => _Compilation2ViewState();
}



class _Compilation2ViewState extends State<Compilation2View> {


  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;


  APIResponse<List<ErrorCategory>> _apiAllErrorCategorys;
  List _allErrorCategories = [];
  List  _myErrorCategories= [];
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    String demoString = "";
    print("Hi");
    setState(() {
      _isLoading = true;
    });
    notesService.getCompilation1Model("1")
        .then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.error) {
        errorMessage = response.errorMessage ?? 'An error occurred';
      }
      widget.note = response.data;


      for (var project in widget.note)
      {
        var tmp = project.component;
        demoString="";
        for(var i = 0; i <tmp.length; ++i)
        {
          var sub = tmp[i].toString().split(":")[0].substring(1);
          demoString+= sub+ ":\n";
          for(var s in tmp[i][sub]){

            if(s[1] == "beseitigt")
            {

              Duration difference = DateTime.parse(s[3]).difference(DateTime.parse(s[2]));
              demoString+= s[0]+": " + difference.inDays.toString()+" Tage\n" ;
            }

          }

        }
        widget.com.add(demoString);

      }
    });

  }

  _getErrorCategorie() async{

    _apiAllErrorCategorys = await notesService.getErrorCategorieList();

    for(var row in _apiAllErrorCategorys.data.toList())
    {
      _allErrorCategories.add({
        "display": row.name,
        "value": row.id,
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( "View 2" )),

      body: _isLoading ? Center(child: CircularProgressIndicator()) :ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: widget.note.length,
          itemBuilder:(context, item){
            return _buildRow(widget.note[item], widget.com[item]);
          }

      ),
    );
  }


  Widget _buildRow(Compilation1Model data, String subtitle){
    return Container(
      child: ListTile(
        title: Text(data.name),
        subtitle: Text(subtitle),

      ),
    );

  }
}