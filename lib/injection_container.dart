import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_assignment/features/todo/presentation/bloc/theme_bloc/theme_cubit.dart';
import 'features/todo/data/data_sources/local_storage_todos_api.dart';
import 'features/todo/data/repositories/todos_repository.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  LocalStorageTodosApi localStorageTodosApi =
      sl.registerSingleton<LocalStorageTodosApi>(
          LocalStorageTodosApi(plugin: sl()));

  sl.registerSingleton<TodosRepository>(
      TodosRepository(todosApi: localStorageTodosApi));

  sl.registerSingleton<ThemeCubit>(ThemeCubit());
}
