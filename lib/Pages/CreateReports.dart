import 'package:flutter/material.dart';
import 'package:technischer_dienst/Controller/FileHandler.dart';
//TODO Check if this works
class CreateReportPage extends StatefulWidget {
  const CreateReportPage(
      {super.key, required this.title, required this.filename});

  final String title;
  final String filename;

  @override
  State<StatefulWidget> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  late List<ReportCategory> _reportData;

  @override
  void initState() {
    super.initState();

    getJsonFileData(widget.filename).then((value) {
      if (value != null) {
        List<dynamic> reportData = value;
        _reportData = List<ReportCategory>.generate(reportData.length, (index) {
          return ReportCategory(
              categoryName: reportData[index]['name'],
              //converting JSON array to map key: e, value: false
              items: {for (var e in reportData[index]['items']) e: false});
        });
      }
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
          child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _reportData[index].isExpanded = isExpanded;
          });
        },
        children: _reportData.map<ExpansionPanel>((ReportCategory category) {
          return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(category.categoryName),
              );
            },
            body: ListView.builder(
              itemCount: category.items.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(category.items.keys.elementAt(index)),
                  trailing: Checkbox(
                    value: category.items.values.elementAt(index),
                    onChanged: (newValue){
                        setState(() {
                          category.items.update(category.items.keys.elementAt(index), (value) => newValue!);
                        });
                    },
                  ),
                );
              },
            ),
            isExpanded: category.isExpanded,
          );
        }).toList(),
      )),
    );
  }
}

class ReportCategory {
  String categoryName;
  Map<String, bool> items;
  bool isExpanded;

  ReportCategory({
    required this.categoryName,
    required this.items,
    this.isExpanded = false,
  });
}
