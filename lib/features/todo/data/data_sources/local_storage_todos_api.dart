import 'dart:async';
import 'dart:convert';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/todos_api.dart';
import '../model/todo.dart';

class LocalStorageTodosApi extends TodosApi {
  LocalStorageTodosApi({
    required this.plugin,
  }) {
    _init();
  }

  final SharedPreferences plugin;

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  static const todosCollectionKey = 'todos_collection';

  String? _getValue(String key) => plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      plugin.setString(key, value);

  void _init() {
    final todosJson = _getValue(todosCollectionKey);
    if (todosJson != null) {
      final todos = List<Map<dynamic, dynamic>>.from(
        json.decode(todosJson) as List,
      )
          .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }

    _todoStreamController.add(todos);
    return _setValue(todosCollectionKey, json.encode(todos));
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex != -1) {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(todosCollectionKey, json.encode(todos));
    }
  }
}
