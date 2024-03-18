import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_assignment/features/todo/presentation/bloc/theme_bloc/theme_cubit.dart';
import '../features/todo/data/repositories/todos_repository.dart';
import '../features/todo/presentation/bloc/add_todo/add_todo_bloc.dart';
import '../features/todo/presentation/bloc/todo_bloc/todos_overview_bloc.dart';
import '../features/todo/presentation/pages/home_page.dart';
import '../injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ThemeCubit>(),
        ),
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: sl<TodosRepository>(),
          )..add(const TodosOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => AddTodoBloc(
            todosRepository: sl<TodosRepository>(),
            initialTodo: null,
          ),
        )
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(useMaterial3: true),
            theme: ThemeData.light(useMaterial3: true),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
