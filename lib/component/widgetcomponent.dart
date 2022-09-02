import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo__app/bloc/cubit.dart';

Widget buildtask(Map li, context) {
  return Dismissible(
    key: ValueKey('${li['id']}'),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDatabase(id: li['id']);
    },
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Row(children: [
        CircleAvatar(
          radius: 40,
          child: Text("${li['title']}"),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${li['date']}'),
              SizedBox(width: 5),
              Text('${li['time']}')
            ],
          ),
        ),
        const SizedBox(width: 15),
        IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(statue: 'done', id: li['id']);
              print('========${li}  =====');
              print('========${li['id']}======mostafa ====');
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        SizedBox(width: 20),
        IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(statue: 'archived', id: li['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.grey,
            )),
      ]),
    ),
  );
}

Widget buildTasks(List<Map> tasks) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildtask(tasks[index], context),
        separatorBuilder: (context, index) => Container(
              color: Colors.grey,
              width: double.infinity,
              height: 2,
            ),
        itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 100,
          ),
          Text("No Tasks Yet, Please Add Some Tasks")
        ],
      ),
    ),
  );
}
