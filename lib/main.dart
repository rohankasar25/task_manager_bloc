import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager_bloc/repository/api_provider.dart';
import 'package:task_manager_bloc/repository/auth_repository.dart';
import 'package:task_manager_bloc/repository/todo_helpers.dart';
import 'package:task_manager_bloc/screens/landing_screen.dart';

import 'bloc/authentication_bloc/authentication_bloc.dart';
import 'bloc/authentication_bloc/authentication_events.dart';
import 'bloc/todo_bloc/todo_bloc.dart';
import 'bloc/todo_bloc/todo_events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('todoBox');
  print("This is box length ${box.length}");
  for (var element in box.values) {
    print(element);
  }
  runApp(MyApp(box: box));
}

class MyApp extends StatelessWidget {
  final Box box;
  const MyApp({super.key, required this.box});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(AuthRepository(box))..add(AppStarted()),
          ),
          BlocProvider(
            create: (_) => TaskBloc(
              TodoRepository(TodoApiService(), box),
            )..add(LoadTasks()),
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthGate(),
        ),
      ),
    );
  }
}
