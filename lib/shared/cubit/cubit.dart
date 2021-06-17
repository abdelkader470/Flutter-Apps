import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app0/layout/news_app/cubit/states.dart';
import 'package:flutter_app0/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:flutter_app0/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:flutter_app0/modules/todo_app/new_tasks/new_tasks_screen.dart';
import 'package:flutter_app0/shared/cubit/states.dart';
import 'package:flutter_app0/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTaskScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNabBarStates());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opended ');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }

  Future insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status) VALUES("$title","$time","$date","new")',
      )
          .then((value) {
        print('$value inserted successfully ');
        emit(AppInsertDatabaseStates());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when create table ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingStates());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseStates());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status =? WHERE id=?', ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseStates());
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id=?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseStates());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetStates());
  }

  bool isDark = false;
  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {});
      emit(AppChangeModeState());
    }
  }
}
