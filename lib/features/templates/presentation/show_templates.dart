import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/templates/application/templateBloc/template_bloc.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import '../../../Constants/assest_images.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../../authentication/application/AuthBloc/auth_bloc.dart';
import '../../reports/presentation/create_reports.dart';
import '../../reports/presentation/report_list.dart';
import 'components/report_card.dart';
import 'edit_templates.dart';

class ShowTemplates extends StatefulWidget {
  const ShowTemplates({super.key, required this.title});

  final String title;

  @override
  State<ShowTemplates> createState() => _ShowTemplatesState();
}

class _ShowTemplatesState extends State<ShowTemplates> {
  final formKey = GlobalKey<FormState>();

  void openEditReportPage(Template template) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditTemplatePage(
                template: template,
                templateExists: true,
              )),
    );
  }

  ImageProvider resolveImage(Template template) {
    ImageProvider image = const AssetImage(AssetImages.noImageTemplate);
    if (template.image.isNotEmpty) {
      final File file = File(template.image);

      if (file.existsSync()) {
        image = FileImage(File(template.image));
      } else {
        try {
          image = NetworkImage(template.image);
        } catch (e) {
          debugPrint(e.toString());
        }
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
                        id: Random().nextInt(10000).toString(),
                        name: addController.text,
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
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (state is Authenticated)
                  UserAccountsDrawerHeader(
                      accountName: Text(state.user.username),
                      accountEmail: Text(state.user.email),
                      currentAccountPicture: CircleAvatar(foregroundImage: _renderImage(state.user.profileImage)),),

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
          );
        },
      ),
      body: BlocBuilder<TemplateBloc, TemplateState>(builder: (context, state) {
        if (state is TemplatesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TemplatesLoaded) {
          if (state is TemplateActionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ));
          }

          return Center(
            child: ListView(
              children: [
                for (Template tmp in state.templates) ...{
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
                        openEditReportPage(tmp);
                      },
                      onDelete: () {
                        context
                            .read<TemplateBloc>()
                            .add(DeleteTemplate(template: tmp));
                      },
                      pickImage: () {
                        context
                            .read<TemplateBloc>()
                            .add(AddImage(template: tmp));
                      },
                    ),
                  ),
                }
              ],
            ),
          );
        }

        if (state is TemplatesError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Etwas ist schief gelaufen'));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildDialog();
        },
        tooltip: 'Berichtsvorlage erstellen',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ImageProvider _renderImage(String profileImagePath) {
    ImageProvider profileImage;

    if(profileImagePath.isNotEmpty){
      profileImage = NetworkImage(profileImagePath);
    } else{
      profileImage = AssetImage(AssetImages.noImageUser);
    }

    return profileImage;
  }
}
