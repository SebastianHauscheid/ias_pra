
import 'package:flutter/material.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/component_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';
import 'package:resttutiral/views/modify/component_modify.dart';
import 'package:resttutiral/views/note_delete.dart';

import 'package:get_it/get_it.dart';

import '../view/error_view.dart';
import '../menu.dart';



class ComponentList extends StatefulWidget {

  @override
  _ComponentListState createState() => _ComponentListState();
}



class _ComponentListState extends State<ComponentList> {
  NotesService get service => GetIt.I<NotesService>();
  APIResponse<List<ComponentModel>> _apiResponse;
  bool _isLoading = false;


  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes()async{
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getComponentList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isSw = true;

    if(UserModel.role == "sw")
    {
      isSw = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('List of Components'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => (  Menu() ))) .then((_) {
                  _fetchNotes();
                });
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ComponentModify()))
                .then((_) {
              _fetchNotes();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errorMessage));
            }

            return ListView.separated(

              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].name),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());
                    print(result);
                    if(result)
                    {
                      final deleteResult = await service.deleteComponent(_apiResponse.data[index].id);
                      var message;
                      if (deleteResult != null && deleteResult.data == true) {
                        message = 'The note was deleted successfully';
                      } else {
                        message = deleteResult?.errorMessage ?? 'An error occured';
                      }

                    }

                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(

                    title: Text(
                      _apiResponse.data[index].name,
                      style: TextStyle(color: Colors.black),

                    ),

                    onTap: () {

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ( isSw ? ComponentModify(id: _apiResponse.data[index].id):
                          ErrorView(noteID: _apiResponse.data[index].name) ))) .then((_) {
                        _fetchNotes();
                      });
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
  }
}