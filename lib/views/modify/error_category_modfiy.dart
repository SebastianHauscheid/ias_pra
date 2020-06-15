
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/cause_of_error.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class ErrorCategorieModify extends StatefulWidget {
  final String mode;
  final id;
  ErrorCategorieModify({this.mode, this.id});

  @override
  _ErrorCategorieModifyState createState() => _ErrorCategorieModifyState();
}



class _ErrorCategorieModifyState extends State<ErrorCategorieModify> {

  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;

  ErrorCategory note;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();


  bool _isLoading = false;
  bool _isModeErrorCategory = true;
  bool get isEditing => widget.id != null;
  @override
  void initState() {
    super.initState();
    if(widget.mode == "component")
    {
      _isModeErrorCategory = false;
    }

    if(isEditing)
      {
        setState(() {
          _isLoading = true;
        });
        notesService.getErrorCategory(widget.id)
            .then((response) {

          if (response.error) {
            errorMessage = response.errorMessage ?? 'An error occurred';
          }
          note = response.data;
          _titleController.text = note.name;



        });
      }

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

            Text("fehlerkategorien"),

            Container(height: 8),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
            ),

            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                  hintText: 'Beschreibung'
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

                  final note = ErrorCategory(
                    name: _titleController.text,
                    description: _contentController.text
                  );
                  var result;
                  if(_isModeErrorCategory)
                    {
                        result = await notesService.createErrorCategorie(note);
                    }
                  else{
                      result = await notesService.createCauseOfErrorCategorie(note);
                  }


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