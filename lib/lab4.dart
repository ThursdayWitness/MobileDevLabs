import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late final String? id;
  late final String title;
  late final String? description;
  late final DateTime deadline;
  late bool isCompleted;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.deadline,
      required this.isCompleted});
}

class Lab4 extends StatefulWidget {
  const Lab4({Key? key}) : super(key: key);

  @override
  State<Lab4> createState() => _Lab4State();
}

class _Lab4State extends State<Lab4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Список дел"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddTask()))
                    .then((value) => setState(() => {}));
              },
            )
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: getFromDB(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!.docs;
              return ListView(
                children: [
                  for (var task in data)
                    TaskBox(
                        callback: setState,
                        task: Task(
                            id: task.id,
                            title: task["title"],
                            description: task["description"],
                            deadline: (task["deadline"] as Timestamp).toDate(),
                            isCompleted: task["isCompleted"]))
                ],
              );
            }
            return const Text("loading");
          },
        ));
  }
}

class TaskBox extends StatelessWidget {
  final Task task;
  final void Function(void Function())? callback;

  const TaskBox({this.callback, required this.task, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Card(
        child: !task.isCompleted
            ? ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => TaskCard(task: task)))
                      .then((value) => callback!(() => {}));
                },
                title: Text(
                  // task.id == null ? "null" : task.id!,
                  task.title.length > 15
                      ? task.title.substring(0, 15) + '...'
                      : task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  task.description == null
                      ? ""
                      : task.description!.length > 70
                          ? task.description!.substring(0, 70) + '...'
                          : task.description!,
                ),
                trailing: Text(
                    "${task.deadline.day}-${task.deadline.month}-${task.deadline.year}",
                    style: TextStyle(
                        color: DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)
                                    .compareTo(task.deadline) >
                                0
                            ? Colors.red
                            : Colors.black)),
              )
            : ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => TaskCard(task: task)))
                      .then((value) => callback!(() => {}));
                },
                title: Text(
                  task.title.length > 15
                      ? task.title.substring(0, 15) + '...'
                      : task.title,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  task.description == null
                      ? ""
                      : task.description!.length > 70
                          ? task.description!.substring(0, 70) + '...'
                          : task.description!,
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                ),
              ),
      ),
    );
  }
}

class AddTask extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTitle = TextEditingController();
    final controllerDesc = TextEditingController();
    DateTime deadline = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавление"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          Row(
            children: const [
              Text("Название"),
              Text("*", style: TextStyle(color: Colors.red)),
            ],
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Это обязательное поле.';
              }
              return null;
            },
            controller: controllerTitle,
          ),
          const Text("Краткое описание"),
          TextFormField(
            controller: controllerDesc,
          ),
          Row(
            children: const [
              Text("Срок выполнения"),
              Text("*", style: TextStyle(color: Colors.red)),
            ],
          ),
          CalendarDatePicker(
              initialDate: deadline,
              firstDate: deadline,
              lastDate: DateTime(2222, 12, 31),
              initialCalendarMode: DatePickerMode.day,
              onDateChanged: (value) {
                deadline = value;
              }),
          /*InputDatePickerFormField(
            firstDate: deadline,
            initialDate: deadline,
            lastDate: DateTime(2222, 12, 31),
            errorFormatText: "Введите корректную дату.",
            errorInvalidText: "Введите корректную дату.",
            onDateSaved: (date) {
              deadline = date;
            },
            onDateSubmitted: (date) {
              deadline = date;
            },
          ),*/
          ElevatedButton(
              child: const Text("Добавить"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addTaskToDB(Task(
                      title: controllerTitle.text,
                      description: controllerDesc.text,
                      deadline: deadline,
                      isCompleted: false));
                  Navigator.of(context).pop();
                }
              }),
        ]),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTitle = TextEditingController();
    final controllerDesc = TextEditingController();
    final controllerDate = TextEditingController();
    controllerTitle.text = task.title;
    controllerDesc.text = task.description!;
    controllerDate.text =
        "${task.deadline.day}-${task.deadline.month}-${task.deadline.year}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Подробнее"),
        centerTitle: true,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Название"),
        TextField(
          readOnly: true,
          enabled: false,
          controller: controllerTitle,
        ),
        const Text("Краткое описание"),
        TextField(
          readOnly: true,
          enabled: false,
          controller: controllerDesc,
          minLines: 1,
          maxLines: 100,
          // clipBehavior: Clip.none,
        ),
        const Text("Срок выполнения"),
        TextField(
          readOnly: true,
          enabled: false,
          controller: controllerDate,
        ),
        if (!task.isCompleted)
          ElevatedButton(
              child: const Text("Выполнить"),
              onPressed: () {
                dialogBuilder(context).then((value) {
                  completeTask(task);
                  Navigator.of(context).pop();
                });
              }),
        if (task.isCompleted)
          ElevatedButton(
              onPressed: () {
                confirmDialogBuilder(context, task: task).then((value) {
                });
              },
              child: const Text("Удалить")),
      ]),
    );
  }
}

Future<void> dialogBuilder(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Поздравляем. Задача выполнена'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Ок'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmDialogBuilder(BuildContext context, {required Task task}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content:
            const Text('Вы действительно хотите удалить задачу из списка?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Да'),
            onPressed: () {
              deleteTaskFromDB(task);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Нет"))
        ],
      );
    },
  );
}

Future<QuerySnapshot<Map<String, dynamic>>> getFromDB() async {
  return FirebaseFirestore.instance
      .collection('tasks')
      .orderBy("isCompleted")
      .orderBy("deadline")
      .get();
}

void addTaskToDB(Task task) {
  var data = {
    "title": task.title,
    "description": task.description,
    "deadline": task.deadline,
    "isCompleted": task.isCompleted,
  };
  var dbTasks = FirebaseFirestore.instance.collection('tasks');
  dbTasks.add(data);
}

void completeTask(Task task) {
  var dbTasks = FirebaseFirestore.instance.collection('tasks');
  final doc = dbTasks.doc(task.id);
  doc.update({"isCompleted": true});
}

void deleteTaskFromDB(Task task) {
  var dbTasks = FirebaseFirestore.instance.collection('tasks');
  dbTasks.doc(task.id).delete();
}
