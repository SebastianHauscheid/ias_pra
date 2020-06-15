
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

import 'menu.dart';


class Login extends StatefulWidget {


  @override
  _LoginState createState() => _LoginState();
}



class _LoginState extends State<Login> {

  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;

  ErrorCategory note;
  TextEditingController _username = TextEditingController();
  TextEditingController _password= TextEditingController();


  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Log in")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),

        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(

          children: <Widget>[

            Text("Mitarbeiter: Name:m2  Password:m2"),
            Text("Entwickler_2: Name:e2  Password:e2"),

            Container(height: 8),

            TextField(
              controller: _username,
              decoration: InputDecoration(
                  hintText: 'Username'
              ),
            ),

            TextField(
              controller: _password,
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


                  var result;

                  result = await notesService.getRole(_username.text, _password.text);
                  if(result.data == "SW"  )
                    {
                      UserModel.userName = _username.text;
                      UserModel.role = result.data;
                      UserModel.isSw = true;

                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Menu()));
                    }
                  else if(result.data == "QW")
                    {
                      UserModel.userName = _username.text;
                      UserModel.role = result.data;
                      UserModel.isSw = false;

                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Menu()));
                    }
                  setState(() {
                    _isLoading = false;
                  });

                  final title = 'Done';
                  final text = result.error ? (result.errorMessage ?? 'An error occurred') : result.data;
/*
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
                  });*/


                },
              ),
            )
          ],
        ),
      ),
    );
  }
}