import 'package:flutter/material.dart';
import 'package:quick_task/models/task.dart';
import 'package:quick_task/services/task_service.dart';
import 'package:logger/logger.dart';
import 'package:quick_task/services/user_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  final UserService _userService = UserService();
  List<Task> _tasks = []; // List to hold tasks
  final Logger _logger = Logger();
  bool isLoggedIn = false;
  
  @override
  void initState() {
    super.initState();
    checkUserStatus();
    _loadTasks(); // Load tasks when the screen is first built
  }

   Future<void> checkUserStatus() async {
    final currentUser = await _userService.getCurrentUserId();
    setState(() {
      isLoggedIn = currentUser != null;
    });
  }

  // Method to load tasks (this could fetch tasks from the backend)
  Future<void> _loadTasks() async {

    final tasks = await _taskService.getTasks(_userService.getCurrentUserId()); // Replace `userId` with the logged-in user's ID
    setState(() {
      _tasks = tasks;
    });
  }

  // Method to handle toggling task status
  Future<void> _toggleTaskStatus(String taskId) async {
    try {
      await _taskService.toggleTaskStatus(taskId); // Call the toggle method
      _loadTasks(); // Reload the task list to reflect the change
    } catch (e) {
      // Handle error (e.g., show a snackbar or alert)
      _logger.e('Error toggling task status: $e');
    }
  }

  // Method to delete a task
  Future<void> _deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId); // Call delete method on task
      _loadTasks(); // Reload the task list after deletion
    } catch (e) {
      // Handle error (e.g., show a snackbar or alert)
      _logger.e('Error deleting task: $e');
    }
  }

   // Navigate to Add Task Screen or Add Directly
  void _navigateToAddTaskScreen(BuildContext context) async {
    final added = await Navigator.pushNamed(context, '/addTask'); // Ensure route exists
    if (added == true) {
      _loadTasks(); // Reload tasks if a new task is added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Go back to the previous screen
          },
        ),
      ),
      body: _tasks.isEmpty ? const Center(
            child: Text(
              'No tasks found. Add a task to get started!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: _tasks.length, // Number of tasks in the list
            itemBuilder: (context, index) {
              final task = _tasks[index]; // Get the task at the current index

              return ListTile(
                title: Text(task.title), // Display the task title
                subtitle: Text(task.isCompleted ? 'Completed' : 'Incomplete'), // Display task status
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank), // Toggle icon
                      onPressed: () {
                        _toggleTaskStatus(task.id); // Toggle task status
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete), // Delete icon
                      onPressed: () {
                        _deleteTask(task.id); // Call the delete method when the icon is pressed
                      },
                    )
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToAddTaskScreen(context),
            tooltip: 'Add Task', // Navigate to add task screen
            child: const Icon(Icons.add),
          ),
      );
  }
}
