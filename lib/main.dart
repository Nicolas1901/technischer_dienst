import 'package:flutter/material.dart';
import 'package:technischer_dienst/Components/report_card.dart';
import 'package:technischer_dienst/Controller/FileHandler.dart';
import 'package:technischer_dienst/Pages/editReports.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String trackerData =
      '[{"templateName": "HLF","filename": "hlfTemplate.json"},{"templateName": "MTF","filename": "mtfTemplate.json"},{"templateName": "StLF","filename": "mtfTemplate.json"}]';

  late List templatePaths;

  @override
  void initState() {
    super.initState();
    writeToJson(
        trackerData, "TemplateTracker"); //TODO remove this when App is complete
    getJsonFileData("TemplateTracker.json").then((value) {
      if (value != null) {
        setState(() {
          templatePaths = value;
        });
      }
    });
  }

  void getFileData() {
    //debugPrint(templatePaths[1]['templateName']); //TODO berichtvorlage erstellen Ansicht erstellen
  }

  void printLink(String link) {
    //TODO berichtansicht erstellen und da hin navigieren
    debugPrint(link);
  }

  //Delete Function for popupmenu
  void deleteTemplate(String filename) {
    removeFile(filename);
    setState(() {
      templatePaths
          .removeWhere((element) => element['filename'].toString() == filename);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            for (var template in templatePaths) ...{
              Listener(
                onPointerDown: (PointerDownEvent details) =>
                    printLink(template['filename']),
                child: CardExample(
                  reportTitle: template['templateName'],
                ),
              ),
            }
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditReportsPage(templateData: null),
            ),
          );
        },
        tooltip: 'Berichtsvorlage erstellen',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
