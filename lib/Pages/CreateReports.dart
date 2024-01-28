import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technischer_dienst/Repositories/FileRepository.dart';

//TODO Check if this works ... it does'nt ... surprise
class CreateReportPage extends StatefulWidget {
  const CreateReportPage(
      {super.key, required this.title, required this.filename});

  final String title;
  final String filename;

  @override
  State<StatefulWidget> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final FileRepository _fileRepo = FileRepository();
  final List<ReportCategory> _reportData = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _fileRepo.readFile(widget.filename).then((value){
      List<dynamic> jsonValue = jsonDecode(value);
      for(var category in jsonValue){
        _reportData.add(ReportCategory(categoryName: category['name'], itemData: category['items']));
      }
      setState(() {
        _fileRepo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _reportData.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                for (ReportCategory category in _reportData) ...{
                  Tab(
                    text: category.categoryName,
                  ),
                }
              ],
            ),
          ),
        ),
      ),

    );
  }
}

class ReportCategory {
  String categoryName;
  List<CategoryItem> items = List.empty(growable: true);

  ReportCategory({
    required this.categoryName,
    required List<dynamic> itemData,
  }){
    for(String item in itemData){
      items.add(CategoryItem(itemName: item, isChecked: false));
    }
  }
}

class CategoryItem {
  String itemName;
  bool isChecked;

  CategoryItem({
    required this.itemName,
    required this.isChecked,
  });
}
