import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo__app/bloc/cubit.dart';

import '../bloc/states.dart';
import '../component/widgetcomponent.dart';

class task extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return buildTasks(AppCubit.get(context).newtasks);
        },
        listener: (context, state) {});
  }
}
