import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _newTask = TextEditingController();
  List<String> TaskList = []; //for Task
  List<String> Status = [];

  ///for Storing th status of task
  @override
  @override
  void initState() {
    super.initState();
    LoadTasks();
  }

  void saveTask() async {
    ///Fns:to Save tasks to the list ,Shared Pref;
    SharedPreferences task = await SharedPreferences.getInstance();
    setState(() {
      if (_newTask.text.isNotEmpty) {
        TaskList.add(_newTask.text);
        Status.add('0');
        task.setStringList('TASK', TaskList);
        task.setStringList('STATUS', Status);
        _newTask.clear();
      }
    });
  }

  void LoadTasks() async {
    ///Fns:For loading from Shared Pref;
    SharedPreferences task = await SharedPreferences.getInstance();
    setState(() {
      TaskList = task.getStringList('TASK') ?? [];
      Status = task.getStringList('STATUS') ?? [];
    });
  }

  void DeleteTask(int index) async {
    ///Fns:to delete Task;
    SharedPreferences task = await SharedPreferences.getInstance();
    setState(() {
      TaskList.removeAt(index);
      Status.removeAt(index);
      task.setStringList('TASK', TaskList);
      task.setStringList('STATUS', Status);
    });
  }

  void setStatus(int index) async {
    //Fns:to Mark Tasks as done;
    SharedPreferences task = await SharedPreferences.getInstance();
    print('koooi');
    setState(() {
      if (index >= 0 && index < Status.length && Status[index] == '0') {
        Status[index] = '1';
      } else {
        Status[index] = '0';
      }
      task.setStringList('STATUS', Status);
      LoadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    //themeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set system overlay style based on the selected theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        body: Column(
          children: [
            ///AppBar
            AppBar(themeProvider: themeProvider),

            ///ListOfTasks
            ListTasks(themeProvider),

            ///AddButton
            AddSection(themeProvider),
          ],
        ),
      ),
    );
  }
///List Tasks
  Expanded ListTasks(ThemeProvider themeProvider) {
    return Expanded(
            child: ListView.builder(
              itemCount: TaskList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Color.fromRGBO(27, 27, 31, 1)
                        : Color.fromRGBO(230, 230, 238, 1),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 1),
                  ),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        setStatus(index);
                      },
                      child: Icon(
                        Status[index] == '1'
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      TaskList[index],
                      style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        DeleteTask(index);
                      },
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
//AddSection
  Container AddSection(ThemeProvider themeProvider) {
    return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
               color: themeProvider.isDarkMode
                        ? Color.fromRGBO(27, 27, 31, 1)
                        : Color.fromRGBO(230, 230, 238, 1),
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _newTask,
                      style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        hintText: 'Add Something...',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    saveTask();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      color: Colors.blue,
                    ),
                    child: Icon(Icons.add, size: 40),
                  ),
                ),
              ],
            ),
          );
  }
}
///AppBar
class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
    required this.themeProvider,
  });

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            size: 40,
            color: Colors.blue,
          ),
          Container(
            alignment: Alignment.centerLeft,
            // margin: EdgeInsets.all(),
            child: Text(
              'Tasks',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          Icon(Icons.search,
          size: 40,color:Colors.blue,
          ),
          // Text('Search',
          //     style: TextStyle(
          //         color: Colors.blue, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

