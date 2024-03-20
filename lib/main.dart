import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:technischer_dienst/features/admin/application/manage_users_bloc.dart';
import 'package:technischer_dienst/features/authentication/application/AuthBloc/auth_bloc.dart';
import 'package:technischer_dienst/features/authentication/presentation/login.dart';
import 'package:technischer_dienst/features/reports/application/createReportBloc/create_report_bloc.dart';
import 'package:technischer_dienst/features/reports/application/reportsBloc/reports_bloc.dart';
import 'package:technischer_dienst/features/reports/data/report_repository.dart';
import 'package:technischer_dienst/features/templates/application/editTemplateBloc/edit_template_bloc.dart';
import 'package:technischer_dienst/features/templates/application/templateBloc/template_bloc.dart';
import 'package:technischer_dienst/features/templates/data/templateRepository.dart';
import 'package:technischer_dienst/features/templates/presentation/show_templates.dart';
import 'package:technischer_dienst/shared/application/connection_bloc/connection_bloc.dart';
import 'features/authentication/data/user_repository.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Data Provider
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  //Repositories
  getIt.registerSingleton<TemplateRepository>(TemplateRepository(
      firestore: getIt<FirebaseFirestore>(),
      storage: getIt<FirebaseStorage>()));

  getIt.registerSingleton<ReportRepository>(
      ReportRepository(firestore: getIt<FirebaseFirestore>()));

  getIt.registerSingleton(UserRepository(
      db: getIt<FirebaseFirestore>(), fireAuth: getIt<FirebaseAuth>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NetworkBloc()..add(NetworkObserve())),
        BlocProvider(
            create: (context) =>
                AuthBloc(userRepository: getIt<UserRepository>())),
        BlocProvider(create: (context) => EditTemplateBloc()),
        BlocProvider(
            create: (context) => TemplateBloc(
                getIt<TemplateRepository>(), context.read<EditTemplateBloc>())
              ..add(const LoadTemplates())),
        BlocProvider(create: (context) => CreateReportBloc()),
        BlocProvider(
            lazy: false,
            create: (context) => ReportsBloc(
                createReportBloc: context.read<CreateReportBloc>(),
                reportRepository: getIt<ReportRepository>())),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocListener<NetworkBloc, NetworkState>(
          listenWhen: (prevousState, state){
            return !(prevousState is NetworkInitial && state is Connected);
          },
          listener: (context, state) {
            if (state is Disconnected) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Keine Internetverbindung"),
                duration: Duration(seconds: 3),
              ));
            }
            if (state is Connected) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.lightGreen,
                content: Text("Verbunden"),
                duration: Duration(seconds: 3),
              ));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState state) {
              if (state is Authenticated) {
                return const ShowTemplates(title: "Vorlagen");
              }

              if (state is LoggedOut) {
                return const Login();
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
