
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/component_model.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/projekt_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class ProjectModify extends StatefulWidget {
  final String id;
  ProjectModify({this.id});

  @override
  _ProjectModifyState createState() => _ProjectModifyState();
}



class _ProjectModifyState extends State<ProjectModify> {

  NotesService get notesService => GetIt.I<NotesService>();

  List _allComponents= [];
  List  _myComponent= [];

  String errorMessage;


  TextEditingController _titleController = TextEditingController();
  APIResponse<List<ComponentModel>> _apiAllComponents;
  Project note;
  bool _isLoading = false;
  bool get isEditing => widget.id != null;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    if(isEditing)
    {
      notesService.getProject(widget.id)
          .then((response) {

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
         note = response.data;
        _titleController.text = note.name;

        for(var item in note.component)
        {
          _myComponent.add(item.toString());
        }

      });
    }

    _getErrorCategorie();

  }

  _getErrorCategorie() async{

    _apiAllComponents = await notesService.getComponentList();

    for(var row in _apiAllComponents.data.toList())
    {
      _allComponents.add({
        "display": row.name,
        "value": row.id,
      });

    }
    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    //List errorCategories = note.errorCategories;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('${_titleController.text}' )),
      body: Padding(
        padding: const EdgeInsets.all(18.0),

        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(

          children: <Widget>[


            Container(height: 8),

            TextField(
              controller: _titleController,
              enabled: (isEditing ? false : true),
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
            ),



            Container(
              padding: EdgeInsets.all(16),
              child: MultiSelectFormField(
                autovalidate: false,
                titleText: 'Komponenten',
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return 'Please select one or more options';
                  }
                  return null;
                },
                dataSource: _allComponents ,
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                hintText: 'Please choose one or more',
                initialValue: _myComponent,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    _myComponent = value;
                  });
                },
              ),
            ),
            Container(height: 16),

            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  final note = Project(
                      name: _titleController.text,
                      component: _myComponent
                  );
                  var result;
                  result = await notesService.createProject(note);

                  setState(() {
                    _isLoading = false;
                  });

                  final title = 'Done';
                  final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was updated';

                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                  )
                      .then((data) {
                    if (result.data) {
                      Navigator.of(context).pop();
                    }
                  });


                },
              ),
            )
          ],
        ),
      ),
    );
  }
}