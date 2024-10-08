// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/data/database.dart';
import 'package:todo_list/helpers/task_card.dart';
import 'package:todo_list/helpers/user_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _box = Hive.box('myBox');
  TaskDB db = TaskDB();
  final _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (_box.get("TASKLIST") == null) {
      db.createTask();
    } else
      db.loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          elevation: 3,
          shadowColor: Colors.black,
          title: Center(
              child: Text("To-do List", style: TextStyle(color: Colors.white))),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogBox(
                    controller: _controller,
                    onSave: () {
                      setState(() {
                        db.taskList.add([_controller.text, false]);
                        _controller.clear();
                        Navigator.of(context).pop();
                        db.updateData();
                      });
                    },
                    onCancel: () => Navigator.of(context).pop(),
                  );
                },
              );
            },
            child: Icon(Icons.add)),
        body: ListView.builder(
          itemCount: db.taskList.length,
          itemBuilder: (context, index) {
            return Task(
              task: db.taskList[index][0],
              accomplished: db.taskList[index][1],
              deleteTask: (context) {
                setState(() {
                  db.taskList.removeAt(index);
                });

                db.updateData();
              },
              onChanged: (p0) {
                setState(() {
                  db.taskList[index][1] = !db.taskList[index][1];
                });
              },
            );
          },
        ));
  }
}
