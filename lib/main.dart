import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/task_screen.dart';
import 'screens/add_task_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {

   WidgetsFlutterBinding.ensureInitialized();

  // Initialize Parse SDK
    await Parse().initialize(
      'IbjYaExlbLNYkkoT1E7mNSYt0YNHU0TeQnZh8Tji', // Replace with your actual Application ID
      'https://parseapi.back4app.com/', // The Parse Server URL
      clientKey: 'ByOSXly6MYHNggK9toNk1jPOfC84rNUgRBPWMH9a', // Optional, replace with your client key if applicable
    );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickTask',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/taskList': (context) => const TaskListScreen(),
        '/addTask': (context) => const AddTaskScreen(),
      },
    );
  }
}
