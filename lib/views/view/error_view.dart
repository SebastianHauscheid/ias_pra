
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/services/notes_service.dart';


class ErrorView extends StatefulWidget {

  final String noteID;
  ErrorView({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<ErrorView> {
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
  List _allErrorCategories = [];
  List  _myErrorCategories= [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getError(widget.noteID)
          .then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        note = response.data;
        _key.text = note.key;
        _titleController.text = note.key;
        _contentController.text = note.beschreibung;
        _id.text = note.id;
       // _causeOfError.text = note.causeOfError;
        _qs_bearbeiter.text = note.qs_bearbeiter;
        _createDateTime.text = note.createDateTime.toString();

        _status.text = note.status;
        _sw_bearbeiter.text = note.sw_bearbeiter;
        _sw_beschreibung.text = note.sw_beschreibung;

        for(var item in note.errorCategories)
        {
          _errorCategories.text += item.toString();
          _myErrorCategories.add(item.toString());
        }
      });
    }
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
      appBar: AppBar(title: Text( _titleController.text )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),

        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[

            Text("Name"),
            TextField(
              enabled: false,
              controller: _titleController,

            ),
            Container(height: 8),

            Text("Beschrebung"),
            TextField(
              controller: _contentController,
              enabled: false,
            ),
            Container(height: 8),

            Text("Status"),
            TextField(
              enabled: false,
              controller: _status,
            ),



            Text("Fehlerursache"),
            TextField(
              enabled: false,
              controller: _causeOfError,
            ),

            Text("Fehler Beschreibung"),
            TextField(
              enabled: false,
              controller: _sw_beschreibung,
            ),

            Text("Bearbeiter"),
            TextField(
              enabled: false,
              controller: _sw_bearbeiter,
            ),

            Container(height: 16),


          ],
        ),
      ),
    );
  }
}