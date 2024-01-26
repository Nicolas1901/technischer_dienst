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
      home: const MyHomePage(title: 'Vorlagen'),
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
  List templatePaths = List.empty();

  @override
  void initState() {
    super.initState();
    writeToJson(
        '[{"templateName": "HLF","filename": "hlfTemplate.json"},{"templateName": "MTF","filename": "mtfTemplate.json"},{"templateName": "StLF","filename": "mtfTemplate.json"},{"templateName": "Titel", "filename": "TitelTemplate"}]',
        "TemplateTracker");
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

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Berichtstitel"),
            content: TextFormField(
              controller: addController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Titel darf nicht leer sein";
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('erstellen'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EditReportsPage(
                        templateFilename: null,
                        title: addController.text,),
                      )).then((value) {
                        getJsonFileData("TemplateTracker.json").then((value) {
                          setState(() {
                            if (value != null) {
                            templatePaths = value;
                            }
                          });
                        });
                      });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
        child: ListView(
          children: [
            for (var template in templatePaths) ...{
              GestureDetector(
                onTap: (){
                  print(template['filename']);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EditReportsPage(
                        templateFilename: template['filename'],
                        title: template['templateName'] )),
                    );
                  },
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
          buildDialog();
        },
        tooltip: 'Berichtsvorlage erstellen',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
