import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technischer_dienst/features/authentication/presentation/login.dart';
import 'package:technischer_dienst/features/templates/application/templateBloc/template_bloc.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import 'package:technischer_dienst/shared/presentation/components/td_navigation_drawer.dart';
import '../../../Constants/assest_images.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../../authentication/application/AuthBloc/auth_bloc.dart';
import '../../reports/presentation/create_reports.dart';
import '../application/editTemplateBloc/edit_template_bloc.dart';
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

  onLogout() {
    debugPrint("Logout");
    Navigator.pop(context);
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
          if (state is Authenticated) {
            return TdNavigationDrawer(
              accountName: state.user.username,
              email: state.user.email,
              avatar: state.user.profileImage,
              selectedIndex: 0,
            );
          } else {
            return const TdNavigationDrawer(
              accountName: '',
              email: '',
              avatar: '',
              selectedIndex: 0,
            );
          }
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
                        context
                            .read<EditTemplateBloc>()
                            .add(EditTemplateLoad(template: tmp));
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => EditTemplatePage(
                                    template: tmp,
                                    templateExists: true,
                                  )),
                        );
                      },
                      onDelete: () {
                        context
                            .read<TemplateBloc>()
                            .add(DeleteTemplate(template: tmp));
                      },
                      pickImage: () {
                        chooseImageSource(tmp);
                      },
                    ),
                  ),
                }
              ],
            ),
          );
        }

        if (state is TemplatesError) {
          debugPrint(state.message);
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

  chooseImageSource(Template tmp) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<TemplateBloc>().add(AddImage(template: tmp));
                    },
                    child: const Column(
                      children: [Icon(Icons.camera_alt), Text("Kamera")],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<TemplateBloc>().add(
                          AddImage(template: tmp, source: ImageSource.gallery));
                    },
                    child: const Column(
                      children: [Icon(Icons.image), Text("Gallerie")],
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
