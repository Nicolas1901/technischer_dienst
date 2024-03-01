import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/features/templates/presentation/showTemplates.dart';
import 'package:technischer_dienst/shared/presentation/components/dialog.dart';
import 'package:technischer_dienst/features/templates/presentation/components/report_card.dart';
import 'package:technischer_dienst/Constants/Filenames.dart';
import 'package:technischer_dienst/Constants/assestImages.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import 'package:technischer_dienst/features/templates/domain/templatesModel.dart';
import 'package:technischer_dienst/features/reports/presentation/CreateReports.dart';
import 'package:technischer_dienst/features/reports/presentation/ReportList.dart';
import 'package:technischer_dienst/features/templates/presentation/editTemplate.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';
import 'package:technischer_dienst/Repositories/ImageRepository.dart';

void main() {
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