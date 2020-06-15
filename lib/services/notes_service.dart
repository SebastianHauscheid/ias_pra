import 'dart:convert';

import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/compilation_1_model.dart';
import 'package:resttutiral/models/component_model.dart';
import 'package:resttutiral/models/error_categorie.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:http/http.dart' as http;
import 'package:resttutiral/models/projekt_model.dart';

class NotesService{
  //static const  url = 'http://api.notes.programmingaddict.com';
  static const  url = 'http://127.0.0.1:8080';



  static const headers = {
    'content-type': 'application/json'
  };


  Future<APIResponse<List<ErrorModel>>> getErrorList() {
    return http.get(url + "/fehler").then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
       // final t =
       // Map<String, dynamic> rows = jsonDecode(jsonData[0]);
        final notes = <ErrorModel>[];
        var entryList = jsonData.entries.toList();

        for( var row in entryList)
          {
            final note = ErrorModel(
              key: row.key,
              id: row.value["id"].toString(),
              beschreibung: row.value["qs_beschreibung"],
              status: row.value["status"],
              createDateTime:DateTime.parse(row.value["qs_datum"]),
              sw_datum:  row.value["sw_datum"] != "null"
                  ? DateTime.parse(row.value["sw_datum"])
                  : DateTime.parse(row.value["qs_datum"]),
            );
            notes.add(note);
          }
        return APIResponse<List<ErrorModel>>(data: notes);
      }
      return APIResponse<List<ErrorModel>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<ErrorModel>>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<ErrorCategory>>> getErrorCategorieList() {
    return http.get(url + "/katfehler").then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        final notes = <ErrorCategory>[];
        var entryList = jsonData.entries.toList();

        for( var row in entryList)
        {
          final note = ErrorCategory(
            id: row.value['id'].toString(),
            name: row.key,
            description: row.value['beschreibung']
          );
          notes.add(note);
        }
        return APIResponse<List<ErrorCategory>>(data: notes);
      }
      return APIResponse<List<ErrorCategory>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<ErrorCategory>>(error: true, errorMessage: 'An error occured'));
  }



  Future<APIResponse<List<ErrorCategory>>> getCauseOfErrorCategorieList() {
    return http.get(url + "/katursache").then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        final notes = <ErrorCategory>[];
        var entryList = jsonData.entries.toList();

        for( var row in entryList)
        {
          final note = ErrorCategory(
              id: row.value['id'].toString(),
              name: row.key,
              description: row.value['beschreibung']
          );
          notes.add(note);
        }
        return APIResponse<List<ErrorCategory>>(data: notes);
      }
      return APIResponse<List<ErrorCategory>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<ErrorCategory>>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<Project>>> getProjectList(String mode) {
    return http.get(url + "/projekt/"+ mode).then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        final notes = <Project>[];
        var entryList = jsonData.entries.toList();

        for( var row in entryList)
        {
          final note = Project(
              id: row.value['id'].toString(),
              name: row.key,
              component: (row.value['komponenten']),

          );
          notes.add(note);
        }
        return APIResponse<List<Project>>(data: notes);
      }
      return APIResponse<List<Project>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<Project>>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<Compilation1Model>>> getCompilation1Model(String mode) {
    return http.get(url + "/projekt/"+ mode).then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        final notes = <Compilation1Model>[];
        var entryList = jsonData.entries.toList();
        //(data: ErrorModel.fromJson(jsonData)
        for( var row in entryList)
        {
          final note = Compilation1Model(
            id: row.value['id'].toString(),
            name: row.key,
            component: (row.value['komponenten']),

          );
          notes.add(note);
        }
        return APIResponse<List<Compilation1Model>>(data: notes);
      }
      return APIResponse<List<Compilation1Model>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<Compilation1Model>>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<ComponentModel>>> getCompilation3Model(String mode) {
    return http.get(url + "/komponente/"+ mode).then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        final notes = <ComponentModel>[];
        var entryList = jsonData.entries.toList();
        //(data: ErrorModel.fromJson(jsonData)
        for( var row in entryList)
        {
          final note = ComponentModel(
            name: row.key,
            erros: (row.value),

          );
          notes.add(note);
        }
        return APIResponse<List<ComponentModel>>(data: notes);
      }
      return APIResponse<List<ComponentModel>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<ComponentModel>>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<ComponentModel>>> getComponentList() {
    return http.get(url + "/komponente").then((data) {
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(data.body);
        final notes = <ComponentModel>[];
        var entryList = jsonData.entries.toList();

        for( var row in entryList)
        {
          final note = ComponentModel(
            name: row.key,
            erros: (row.value['komponenten']),
            id: row.value['id'].toString()

          );
          notes.add(note);
        }
        return APIResponse<List<ComponentModel>>(data: notes);
      }
      return APIResponse<List<ComponentModel>>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<List<ComponentModel>>(error: true, errorMessage: 'An error occured'));
  }


  Future<APIResponse<ErrorModel>> getError(String noteID) {
    return http.get(url + '/fehler/' + noteID, ).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<ErrorModel>(data: ErrorModel.fromJson(jsonData));
      }
      return APIResponse<ErrorModel>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<ErrorModel>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<ErrorCategory>> getErrorCategory(String noteID) {
    return http.get(url + '/katfehler/' + noteID, ).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<ErrorCategory>(data: ErrorCategory.fromJson(jsonData));
      }
      return APIResponse<ErrorCategory>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<ErrorCategory>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<ComponentModel>> getComponent(String noteID) {
    return http.get(url + '/komponente/0/' + noteID, ).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<ComponentModel>(data: ComponentModel.fromJson(jsonData));
      }
      return APIResponse<ComponentModel>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<ComponentModel>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Project>> getProject( String id) {
    return http.get(url + '/projekt/0/' + id, ).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Project>(data: Project.fromJson(jsonData));
      }
      return APIResponse<Project>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<Project>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> getRole( String username, String password) {
    return http.get(url + '/user/' + username + '/'+ password ).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<String>(data: jsonData);;
      }
      return APIResponse<String>(error: true, errorMessage: 'An error occured');
    })
        ;//.catchError((_) => APIResponse<Project>(error: true, errorMessage: 'An error occured'));
  }



  Future<APIResponse<bool>> createError(ErrorModel item) {
    return http.post(url + '/fehler/'+ json.encode(item.toJson()), headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createErrorCategorie(ErrorCategory item) {
    return http.post(url + '/katfehler/', headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createCauseOfErrorCategorie(ErrorCategory item) {
    return http.post(url + '/katursache/', headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createProject(Project item) {
    return http.post(url + '/projekt/', headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createComponent(ComponentModel item) {
    return http.post(url + '/komponente/', headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }



  Future<APIResponse<bool>> updateError(String noteID, ErrorModel item) {
    return http.put(url + '/fehler/' + noteID, headers: headers, body: /*json.encode(item.toSJson())*/ json.encode(item.toJson())).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteError(String noteID) {
    return http.delete(url + '/fehler/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteErrorCategorie(String noteID) {
    return http.delete(url + '/katfehler/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteCauseOfErrorCategorie(String noteID) {
    return http.delete(url + '/katursache/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
//Component
  Future<APIResponse<bool>> deleteProject(String noteID) {
    return http.delete(url + '/projekt/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteComponent(String noteID) {
    return http.delete(url + '/komponente/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }


}