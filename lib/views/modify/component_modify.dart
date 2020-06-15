
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/component_model.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class ComponentModify extends StatefulWidget {
  final String id;
  ComponentModify({this.id});

  @override
  _ComponentModifyState createState() => _ComponentModifyState();
}



class _ComponentModifyState extends State<ComponentModify> {

  NotesService get notesService => GetIt.I<NotesService>();
  bool get isEditing => widget.id != null;
  List  _myError= [];
  List _allError = [];

  String errorMessage;

  ComponentModel note;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  APIResponse<List<ErrorModel>> _apiAllErrorCategorys;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    if(isEditing)
      {
        notesService.getComponent(widget.id)
            .then((response) {

          if (response.error) {
            errorMessage = response.errorMessage ?? 'An error occurred';
          }
          note = response.data;
          _titleController.text = note.name;

          for(var item in note.erros)
          {
            _myError.add(item.toString());
          }

        });
      }
    _getErrorCategorie();

  }

  _getErrorCategorie() async{

    _apiAllErrorCategorys = await notesService.getErrorList();

    for(var row in _apiAllErrorCategorys.data.toList())
    {
      _allError.add({
        "display": row.key,
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
                titleText: 'My workouts',
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return 'Please select one or more options';
                  }
                  return null;
                },
                dataSource: _allError ,
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                // required: true,
                hintText: 'Please choose one or more',
                initialValue: _myError,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    _myError = value;

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

                  final note = ComponentModel(
                      name: _titleController.text,
                      erros: _myError
                  );
                  var result;
                  result = await notesService.createComponent(note);

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