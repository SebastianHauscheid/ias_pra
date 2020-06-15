
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/compilation_1_model.dart';
import 'package:resttutiral/models/component_model.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/projekt_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class Compilation3View extends StatefulWidget {


  List<ComponentModel> note;
  List<String> com = [];
  @override
  _Compilation3ViewState createState() => _Compilation3ViewState();
}



class _Compilation3ViewState extends State<Compilation3View> {


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
    setState(() {
      _isLoading = true;
    });
    notesService.getCompilation3Model("1")
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

        var tmp = project.erros;
        demoString=project.name + "\n";
        for(var s in tmp)
          {
            demoString +=s[0] +": "+s[1] + "\n";
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
      appBar: AppBar(title: Text( "View 3" )),

      body: _isLoading ? Center(child: CircularProgressIndicator()) :ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: widget.note.length,
          itemBuilder:(context, item){
            return _buildRow(widget.note[item], widget.com[item]);
          }

      ),
    );
  }


  Widget _buildRow(ComponentModel data, String subtitle){
    return Container(
      child: ListTile(
        title: Text(data.name),
        subtitle: Text(subtitle),

      ),
    );

  }
}