import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app_assignment/app/app.dart';
import 'app/app_bloc_observer.dart';
import 'injection_container.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  await initializeDependencies();

  runApp(const MyApp());

}