import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo__app/bloc/states.dart';
import '../bloc/cubit.dart';
import 'package:intl/intl.dart';

class homeTodo extends StatelessWidget {
  TextEditingController tasksController = TextEditingController();
  TextEditingController TimeController = TextEditingController();
  TextEditingController DateController = TextEditingController();

  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..creatDatebase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is AppInsertDatabaseState) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Scaffold(
              key: ScaffoldKey,
              appBar: AppBar(
                  title: Text(AppCubit.get(context)
                      .title[AppCubit.get(context).currentIndex])),
              body: AppCubit.get(context)
                  .screens[AppCubit.get(context).currentIndex],
              floatingActionButton: FloatingActionButton(
                child: Icon(AppCubit.get(context).flatIcon),
                onPressed: () {
                  if (AppCubit.get(context).isShown == true &&
                      formKey.currentState.validate()) {
                    AppCubit.get(context).insertData(
                        title: tasksController.text,
                        time: TimeController.text,
                        date: DateController.text);
                  } else {
                    ScaffoldKey.currentState
                        .showBottomSheet(
                            (context) => Container(
                                  padding: const EdgeInsets.all(15),
                                  color: Colors.grey[200],
                                  child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: tasksController,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                icon: Icon(Icons.title),
                                                label: Text(
                                                  'Title',
                                                ),
                                                hintText: 'enter your Title'),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Invalid title';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            onTap: () => showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              TimeController.text = value
                                                  .format(context)
                                                  .toString();
                                            }),
                                            keyboardType:
                                                TextInputType.datetime,
                                            controller: TimeController,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                icon: Icon(Icons.punch_clock),
                                                label: Text('Time'),
                                                hintText: 'enter your Time'),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Invalid Time';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            onTap: () => showDatePicker(
                                                    initialDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        '2024-09-09'),
                                                    firstDate: DateTime.now(),
                                                    context: context)
                                                .then((value) {
                                              DateController.text =
                                                  DateFormat.yMMMMEEEEd()
                                                      .format(value)
                                                      .toString();
                                            }),
                                            keyboardType:
                                                TextInputType.datetime,
                                            controller: DateController,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                icon: Icon(Icons.date_range),
                                                label: Text('Date'),
                                                hintText: 'enter your Date'),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Invalid Date';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )),
                                ),
                            elevation: 20)
                        .closed
                        .then((value) {
                      AppCubit.get(context).changeIcon(false, Icons.edit);
                    });
                    AppCubit.get(context).changeIcon(true, Icons.add);
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: AppCubit.get(context).currentIndex,
                  onTap: (value) {
                    AppCubit.get(context).changeIndex(value);
                  },
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu), label: 'Task'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline), label: 'Done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.architecture_outlined),
                        label: 'Archived'),
                  ]),
            );
          },
        ));
  }
}
