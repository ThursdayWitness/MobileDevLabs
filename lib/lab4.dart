import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String title;
  final String? description;
  late DateTime creationDate;
  // final DateTime deadline;

  Task({this.id, required this.title, required this.description}) {
    creationDate = DateTime.now();
  }
}

class Lab4 extends StatefulWidget {
  const Lab4({Key? key}) : super(key: key);

  @override
  State<Lab4> createState() => _Lab4State();
}

class _Lab4State extends State<Lab4> {
  final dbTasks = FirebaseFirestore.instance
      .collection('tasks')
      .orderBy("creationDate", descending: true);

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
          future: dbTasks.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!.docs;
              // data.sort((a, b) => a['creationDate'] < b['creationDate'],);
              return ListView(
                children: [
                  for (var task in data)
                    TaskBox(
                        callback: setState,
                        task: Task(
                            title: task['title'],
                            description: task['description'],
                            id: task.id))
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
        child: ListTile(
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            task.description == null
                ? ""
                : task.description!.length > 70
                    ? task.description!.substring(0, 70) + '...'
                    : task.description!,
          ),
          // trailing: const InkWell(child: Icon(Icons.check_circle_rounded)), <== НЕ СТИРАТЬ
          // trailing: Text(widget.task.deadline),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавление"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          ElevatedButton(
              child: const Text("Добавить"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addTaskToDB(Task(
                      title: controllerTitle.text,
                      description: controllerDesc.text));
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
    controllerTitle.text = task.title;
    controllerDesc.text = task.description!;
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
        ElevatedButton(
            child: const Text("Выполнить"),
            onPressed: () {
              deleteTaskFromDB(task);
              Navigator.of(context).pop();
            }),
      ]),
    );
  }
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFromDB() async {
  // Get docs from collection reference
  var querySnapshot =
      await FirebaseFirestore.instance.collection('tasks').get();

  // Get data from docs and convert map to List
  return querySnapshot.docs.toList();
}

void addTaskToDB(Task task) {
  var data = {
    "title": task.title,
    "description": task.description,
    "creationDate": task.creationDate
  };
  var dbTasks = FirebaseFirestore.instance.collection('tasks');
  dbTasks.add(data);
}

void deleteTaskFromDB(Task task) {
  var dbTasks = FirebaseFirestore.instance.collection('tasks');
  dbTasks.doc(task.id).delete();
}
