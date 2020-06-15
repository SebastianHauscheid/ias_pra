
import 'package:flutter/material.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/error_categorie.dart';

import 'package:resttutiral/services/notes_service.dart';
import 'package:resttutiral/views/note_delete.dart';

import 'package:get_it/get_it.dart';

import '../modify/error_category_modfiy.dart';
import '../menu.dart';


class ErrorCategoryList extends StatefulWidget {
  final String mode;
  ErrorCategoryList({this.mode});
  @override
  _ErrorCategoryListState createState() => _ErrorCategoryListState();
}


class _ErrorCategoryListState extends State<ErrorCategoryList> {
  NotesService get service => GetIt.I<NotesService>();
  APIResponse<List<ErrorCategory>> _apiResponse;
  bool _isLoading = false;
  bool _isModeErrorCategory = true;




  @override
  void initState() {
    if(widget.mode == "component")
      {
        _isModeErrorCategory = false;
      }
    _fetchNotes();
    super.initState();
  }

  _fetchNotes()async{
    setState(() {
      _isLoading = true;
    });
    if(_isModeErrorCategory)
      {
        _apiResponse = await service.getErrorCategorieList();
      }
    else{
      _apiResponse = await service.getCauseOfErrorCategorieList();
    }


    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text('List of Errors'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ( Menu() ))) .then((_) {
                  _fetchNotes();
                });
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => (_isModeErrorCategory ? ErrorCategorieModify() :ErrorCategorieModify(mode: "component") ) ))
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
                  key: ValueKey(_apiResponse.data[index].id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());
                    print(result);
                    if(result)
                    {
                      var deleteResult;
                      if(_isModeErrorCategory)
                        {
                          deleteResult = await service.deleteErrorCategorie(_apiResponse.data[index].id);
                        }
                      else{
                        deleteResult = await service.deleteCauseOfErrorCategorie(_apiResponse.data[index].id);
                      }
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

                    subtitle: Text(
                        '${_apiResponse.data[index].description} '),

                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
  }
}