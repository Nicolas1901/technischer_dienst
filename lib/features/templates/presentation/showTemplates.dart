import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:technischer_dienst/Constants/Filenames.dart';
import 'package:technischer_dienst/features/templates/domain/templatesModel.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';

import '../../../Repositories/ImageRepository.dart';
import '../../../Constants/assestImages.dart';
import '../../../Repositories/FileRepository.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../../reports/presentation/CreateReports.dart';
import '../../reports/presentation/ReportList.dart';
import 'components/report_card.dart';
import 'editTemplate.dart';

class ShowTemplates extends StatefulWidget {
  const ShowTemplates({super.key, required this.title});

  final String title;

  @override
  State<ShowTemplates> createState() => _ShowTemplatesState();
}

class _ShowTemplatesState extends State<ShowTemplates> {
  final _fileRepo = FileRepository();
  final _imageRepo = ImageRepository();
  List templatePaths = List.empty(growable: true);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fileRepo.createFile(Filenames.REPORTS);
    _fileRepo.createFile(Filenames.TEMPLATES);
    _fileRepo.createDirectory(Filenames.IMAGE_DIR);
    try {
      _fileRepo.readFile(Filenames.TEMPLATES).then((value) {
        List<Template> tmpList = List<dynamic>.from(jsonDecode(value))
            .map((e) => Template.fromJson(e))
            .toList();
        context.read<TemplatesModel>().setup(tmpList);
      });
    } on PathNotFoundException {
      debugPrint("TemplateTracker.json does not exist");
    }
  }

  void openEditReportPage(int id) {
    debugPrint(id.toString());
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditTemplatePage(
            template: context.read<TemplatesModel>().getWhere(id),
            templateExists: true,
          )),
    );
  }

  //Delete Function for popupmenu
  deleteTemplate(Template template) {
    Provider.of<TemplatesModel>(context, listen: false).delete(template);
    _fileRepo.writeFile(
        Filenames.TEMPLATES,
        jsonEncode(
            Provider.of<TemplatesModel>(context, listen: false).templates));
  }

  setImage(Template template){
    _pickImage().then((value){
      final XFile? pickedImage = value;
      if(pickedImage == null) return;

      final String path = "${Filenames.IMAGE_DIR}/${pickedImage.name}";

      pickedImage.readAsBytes().then((bytes){
        _imageRepo.write(path, bytes);
        template.image = path;
        Provider.of<TemplatesModel>(context, listen: false).update(template);
      });
    });

  }

  Future<XFile?> _pickImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    return pickedImage;
  }

  ImageProvider resolveImage(Template template){
    ImageProvider image = const AssetImage(AssetImages.placeholder);
    if(template.image.isNotEmpty) {
      try {
        _imageRepo.get(template.image).then((file) {
          image = FileImage(file);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    debugPrint("resolveImage: ${image.toString()}");
    return image;
  }



  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              onSave: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditTemplatePage(
                      template: Template(
                        id: 0,
                        name: addController.text,
                        image: "",
                        categories: [],
                      ),
                    ),
                  ));
                }
              },
              onAbort: () {
                Navigator.of(context).pop();
              },
              title: "Neue Vorlage",
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: addController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Titel darf nicht leer sein";
                    }
                    return null;
                  },
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text("Technischer Dienst"),
            ),
            ListTile(
                title: const Text("Berichte"),
                leading: const Icon(Icons.file_copy),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReportList()));
                })
          ],
        ),
      ),
      body: Center(
        child: Consumer<TemplatesModel>(
          builder:
              (BuildContext context, TemplatesModel model, Widget? child) =>
              ListView(
                children: [
                  for (Template tmp in model.templates) ...{
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateReportPage(
                            template: tmp,
                          ),
                        ));
                      },
                      child: CardExample(
                        reportTitle: tmp.name,
                        image: resolveImage(tmp),
                        onEdit: () {
                          openEditReportPage(tmp.id);
                        },
                        onDelete: () {
                          deleteTemplate(tmp);
                        },
                        pickImage: (){
                          setImage(tmp);
                        },
                      ),
                    ),
                  }
                ],
              ),
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
