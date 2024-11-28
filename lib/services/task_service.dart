import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/services/user_service.dart';

import '../models/task.dart';

class TaskService {
  final Logger _logger = Logger();
  final UserService _userService = UserService(); 
  // Fetch tasks
  Future<List<Task>> getTasks(userId) async {
    try {

      final currentUser = await _userService.getCurrentUserId();
      if (currentUser == null) {
        throw Exception('User not logged in.');
      }

      // Create a query for the 'Task' class
      final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Tasks'))..whereEqualTo('userId', currentUser);

      // Optionally, you can add sorting, filtering, or limits to the query
      query.orderByDescending('dueDate'); // Example: Order by due date

      // Execute the query
      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        // Map the results to a list of Task objects
        List<Task> tasks = response.results!
            .map((e) => Task.fromParse(e as ParseObject))
            .toList();
        return tasks;
      } else {
        if(response.success && response.count == 0) {
          return [];
        }
        else {
          _logger.e('Failed to fetch tasks');
          throw Exception('Failed to fetch tasks');
        } 
      }
    } catch (e) {
      _logger.e('Error fetching tasks: $e');
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    try {

      final currentUser = await _userService.getCurrentUserId();
      if (currentUser == null) {
        throw Exception('User not logged in.');
      }
      // Create a new ParseObject for the Task class
      final ParseObject taskObject = ParseObject('Tasks')
        ..set('title', task.title)
        ..set('dueDate', task.dueDate)
        ..set('isCompleted', task.isCompleted)
        ..set('userId', currentUser);

      // Save the task object to the backend
      final ParseResponse response = await taskObject.save();

      if (response.success) {
        _logger.i('Task added successfully');
      } else {
        _logger.e('Failed to add task: ${response.error?.message}');
        throw Exception('Failed to add task');
      }
    } catch (e) {
      _logger.e('Error adding task: $e');
      throw Exception('Error adding task: $e');
    }
  }

  // Toggle task status
  Future<void> toggleTaskStatus(String taskId) async {
    try {
      // Create a ParseObject for the Task and set the taskId
      final ParseObject taskObject = ParseObject('Tasks')..objectId = taskId;

      // Fetch the task from the backend (fetch() returns a ParseObject directly)
      final ParseObject fetchedTask = await taskObject.fetch();

      // Get the current status of the task (isCompleted field)
      bool currentStatus = fetchedTask.get<bool>('isCompleted') ?? false;

      // Toggle the status (if true, set false; if false, set true)
      taskObject.set('isCompleted', !currentStatus);

      // Save the updated task to the backend (save() also returns a ParseResponse)
      final ParseResponse saveResponse = await taskObject.save();

      if (saveResponse.success) {
        _logger.i('Task status updated successfully');
      } else {
        _logger.e('Failed to update task status: ${saveResponse.error?.message}');
        throw Exception('Failed to update task status');
      }
    } catch (e) {
      _logger.e('Error toggling task status: $e');
      throw Exception('Error toggling task status: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      // Fetch the task by its objectId
      final taskObject = ParseObject('Tasks')..objectId = taskId;
      final ParseResponse response = await taskObject.delete(); // Delete the task

      if (response.success) {
        _logger.i("Task deleted successfully!");
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      _logger.e('Error deleting task: $e');
      throw Exception('Error deleting task');
    }
  }
}
