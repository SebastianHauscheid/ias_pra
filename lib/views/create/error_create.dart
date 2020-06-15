
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';
import 'package:resttutiral/models/error_categorie.dart';

class ErrorCreate extends StatefulWidget {

  final String noteID;
  ErrorCreate({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}



class _NoteModifyState extends State<ErrorCreate> {
  bool get isEditing => widget.noteID != null;
  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;

  ErrorModel note;
  TextEditingController _key = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _qs_bearbeiter = TextEditingController();
  TextEditingController _createDateTime = TextEditingController();
  TextEditingController _errorCategories = TextEditingController();
  TextEditingController _sw_beschreibung = TextEditingController();
  TextEditingController _sw_bearbeiter = TextEditingController();
  TextEditingController _causeOfError = TextEditingController();
  TextEditingController _status = TextEditingController();
  APIResponse<List<ErrorCategory>> _allErrorCategorys;

  String  _myActivitiesResult = '';
  List _myActivities;
  bool _isLoading = false;
  List allErrorCategories = [];

  @override
  void initState() {
    super.initState();
    _getErrorCategorie();
  }

  _getErrorCategorie()async{
    setState(() {
      _isLoading = true;
    });

    _allErrorCategorys = await notesService.getErrorCategorieList();

    for(var row in _allErrorCategorys.data.toList())
      {
        allErrorCategories.add({
          "display": row.name,
          "value": row.id,
        });
        print(row.description);
      }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Fehler erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),

        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(

          children: <Widget>[


            TextField(

              controller: _titleController,
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                  hintText: 'Beschreibung'
              ),
            ),

            Container(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              child: MultiSelectFormField(
                autovalidate: false,
                titleText: 'Kategorie',
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return 'Please select one or more options';
                  }
                  return null;
                },
                dataSource:allErrorCategories ,
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                // required: true,
                hintText: 'Please choose one or more',
                initialValue: _myActivities,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    _myActivities = value;
                  });
                },
              ),
            ),

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
                    final note = ErrorModel(
                        key: _titleController.text,
                        id: " ",
                        beschreibung: _contentController.text,


                        qs_bearbeiter: UserModel.userName,
                        errorCategories: _myActivities/*errorCategories*/,
                        causeOfError: [],
                        createDateTime:DateTime.now() ,//DateTime.parse(_createDateTime.text),
                        status: "erkannt",
                        sw_beschreibung: _sw_beschreibung.text,
                        sw_bearbeiter: _sw_bearbeiter.text,

                    );
                    final result = await notesService.createError(note);

                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was created';

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