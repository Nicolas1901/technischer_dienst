import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/Constants/DbConnection.dart';
import 'package:technischer_dienst/features/reports/application/createReportBloc/create_report_bloc.dart';
import 'package:technischer_dienst/features/reports/application/reportsBloc/reports_bloc.dart';
import 'package:technischer_dienst/features/templates/application/editTemplateBloc/edit_template_bloc.dart';
import 'package:technischer_dienst/features/templates/application/templateBloc/template_bloc.dart';
import 'package:technischer_dienst/features/templates/data/templateRepository.dart';
import 'package:technischer_dienst/features/templates/presentation/show_templates.dart';
import 'features/reports/application/reportsBloc/MockReports.dart';
import 'features/templates/application/templateBloc/mockTemplates.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<PocketBase>(PocketBase(DbConnectionString.url));
  getIt.registerSingleton<TemplateRepository>(
      TemplateRepository(pb: getIt<PocketBase>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EditTemplateBloc()),
        BlocProvider(
            create: (context) => TemplateBloc(
                getIt<TemplateRepository>(), context.read<EditTemplateBloc>())
              ..add(LoadTemplates(templates: MockTemplates.generate()))),
        BlocProvider(create: (context) => CreateReportBloc()),
        BlocProvider(
          lazy: false,
            create: (context) =>
                ReportsBloc(createReportBloc: context.read<CreateReportBloc>()))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ShowTemplates(title: 'Vorlagen'),
      ),
    );
  }
}
