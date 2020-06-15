
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class ErrorModify extends StatefulWidget {

  final String noteID;
  ErrorModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}



class _NoteModifyState extends State<ErrorModify> {
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
  APIResponse<List<ErrorCategory>> _apiAllErrorCategorys;

  List  _myErrorCategories;
  List  _myCauseOfErrorCategories = [];
  List _allCauseOfErrorCategories = [];
  bool _isLoading = false;

  @override
  void initState() {

    super.initState();
      setState(() {
        _isLoading = true;
      });


     _myErrorCategories = [];
      notesService.getError(widget.noteID)
          .then((response) {

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        note = response.data;
        _key.text = note.key;
        _titleController.text = note.key;
        _contentController.text = note.beschreibung;
        _id.text = note.id;
        _errorCategories.text = note.errorCategories.toString();
        _qs_bearbeiter.text = note.qs_bearbeiter;
        _createDateTime.text = note.createDateTime.toString();

        _status.text = note.status;
        _sw_bearbeiter.text = note.sw_bearbeiter;
        _sw_beschreibung.text = note.sw_beschreibung;

        for(var item in note.causeOfError)
          {
            _myCauseOfErrorCategories.add(item.toString());
          }
        for(var item in note.errorCategories)
        {
          _myErrorCategories.add(item.toString());
        }
      });
    _getErrorCategorie();


  }

  _getErrorCategorie() async{

    _apiAllErrorCategorys = await notesService.getCauseOfErrorCategorieList();

    for(var row in _apiAllErrorCategorys.data.toList())
    {
      _allCauseOfErrorCategories.add({
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



            Container(
              padding: EdgeInsets.all(16),
              child: MultiSelectFormField(
                autovalidate: false,
                titleText: 'Ursache',
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return 'Please select one or more options';
                  }
                  return null;
                },
                dataSource: _allCauseOfErrorCategories ,
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                // required: true,
                hintText: 'Please choose one or more',
                initialValue: _myCauseOfErrorCategories,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    _myCauseOfErrorCategories = value;

                  });
                },
              ),
            ),

            Text("Status"),
            new DropdownButton<String>(
              hint: new Text(_status.text),

              items: <String>['erkannt', 'beseitigt'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _status.text = value;
                });

              },
            ),



            Container(height: 8),

            TextField(
              controller: _sw_beschreibung,
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

                    final note = ErrorModel(
                        id: _id.text,
                        beschreibung: _contentController.text,
                        key: _key.text,
                        sw_datum: DateTime.now(),
                        qs_bearbeiter: _qs_bearbeiter.text,
                        errorCategories: _myErrorCategories,
                        causeOfError:  _myCauseOfErrorCategories,
                        createDateTime:DateTime.parse(_createDateTime.text),
                        status: _status.text,
                        sw_beschreibung: _sw_beschreibung.text,
                        sw_bearbeiter: UserModel.userName

                    );
                    final result = await notesService.updateError(widget.noteID, note);

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