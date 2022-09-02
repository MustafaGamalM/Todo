import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo__app/bloc/states.dart';

import '../modules/archived.dart';
import '../modules/done.dart';
import '../modules/task.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    task(),
    done(),
    archived(),
  ];
  List<String> title = ['Task', 'Done', 'Archived'];
  bool isShown = false;
  IconData flatIcon = Icons.edit;
  int currentIndex = 0;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  changeIcon(bool b, IconData i) {
    isShown = b;
    flatIcon = i;
    emit(AppChangeIconState());
  }

  Database database;
  void creatDatebase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('Database Created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) {
        print('table craeted');
      }).catchError((e) {
        print(e.toString());
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertData(
      {@required String title,
      @required String date,
      @required String time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('successfully $value inserted to data');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((e) {
        print('${e.toString()} error');
      });
      return null;
    });
  }

  void updateDatabase({@required statue, @required id}) async {
    await database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$statue', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void getDataFromDatabase(database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(AppLoadingDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newtasks.add(element);
        else if (element['status'] == 'done')
          donetasks.add(element);
        else
          archivedtasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void deleteFromDatabase({@required id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDelteState());
    });
  }
}
