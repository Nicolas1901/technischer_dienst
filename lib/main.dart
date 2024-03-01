import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/Constants/DbConnection.dart';
import 'package:technischer_dienst/features/templates/data/templateRepository.dart';
import 'package:technischer_dienst/features/templates/presentation/showTemplates.dart';

import 'package:technischer_dienst/features/templates/domain/templatesModel.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<PocketBase>(PocketBase(DbConnectionString.url));
  getIt.registerSingleton<TemplateRepository>(TemplateRepository(pb: getIt<PocketBase>()));

  runApp(ChangeNotifierProvider(
    create: (context) => TemplatesModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShowTemplates(title: 'Vorlagen'),
    );
  }
}